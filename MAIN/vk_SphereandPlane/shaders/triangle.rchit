/*
 * Copyright (c) 2019-2021, NVIDIA CORPORATION.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-FileCopyrightText: Copyright (c) 2019-2021 NVIDIA CORPORATION
 * SPDX-License-Identifier: Apache-2.0
 */

#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_EXT_nonuniform_qualifier : enable
#extension GL_EXT_scalar_block_layout : enable
#extension GL_GOOGLE_include_directive : enable
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_buffer_reference2 : require

#include "raycommon.glsl"
#include "wavefront.glsl"

#extension GL_EXT_debug_printf : enable

#define MAX_RECURSION_DEPTH 31

hitAttributeEXT vec2 attribs;

// clang-format off
layout(location = 0) rayPayloadInEXT hitPayload prd;
//layout(location = 1) rayPayloadEXT bool isthisevennecessary;

layout(buffer_reference, scalar) buffer Vertices {Vertex v[]; }; // Positions of an object
layout(buffer_reference, scalar) buffer Indices {ivec3 i[]; }; // Triangle indices
layout(buffer_reference, scalar) buffer Materials {WaveFrontMaterial m[]; }; // Array of all materials on an object
layout(buffer_reference, scalar) buffer MatIndices {int i[]; }; // Material ID for each triangle

layout(set = 0, binding = eTlas) uniform accelerationStructureEXT topLevelAS;
layout(set = 1, binding = eObjDescs, scalar) buffer ObjDesc_ { ObjDesc i[]; } objDesc;
layout(set = 1, binding = eTextures) uniform sampler2D textureSamplers[];

layout(push_constant) uniform _PushConstantRay { PushConstantRay pcRay; };
// clang-format on



void main()
{ 
  //debugPrintfEXT("prd: %d, %f, %f, %f, depth: %d\n", prd.ray_id, prd.tpath, prd.ref_idx, prd.receive, prd.recursionDepth);

  // Object data
  ObjDesc    objResource = objDesc.i[gl_InstanceCustomIndexEXT];
  MatIndices matIndices  = MatIndices(objResource.materialIndexAddress);
  Materials  materials   = Materials(objResource.materialAddress);
  Indices    indices     = Indices(objResource.indexAddress);
  Vertices   vertices    = Vertices(objResource.vertexAddress);

  // Indices of the triangle
  ivec3 ind = indices.i[gl_PrimitiveID];

  // Vertex of the triangle
  Vertex v0 = vertices.v[ind.x];
  Vertex v1 = vertices.v[ind.y];
  Vertex v2 = vertices.v[ind.z];

  //debugPrintfEXT("prd: %d, %f, %f, %f, depth: %d\n", prd.ray_id, prd.tpath, prd.ref_idx, prd.receive, prd.recursionDepth);

  // updating total path length & recursion depth
  float total_path_length = gl_RayTmaxEXT + prd.tpath;
  prd.tpath = total_path_length;

  // calculating Rv based on Frensel reflection equation
  vec3 edge1 = v1.pos - v0.pos;
  vec3 edge2 = v2.pos - v0.pos;
  vec3 edge_cross = cross(edge1, edge2);
  vec3 out_normal = normalize(edge_cross);

  //debugPrintfEXT("ray id: %d, edge2: (%f, %f, %f)\n", prd.ray_id, edge2.x, edge2.y, edge2.z);
  //debugPrintfEXT("ray id: %d, edge_cross: (%f, %f, %f)\n", prd.ray_id, edge_cross.x, edge_cross.y, edge_cross.z);  
  //debugPrintfEXT("ray id: %d, out_normal: (%f, %f, %f), depth: %d\n", prd.ray_id, out_normal.x, out_normal.y, out_normal.z, prd.recursionDepth);
  vec3 rayDir = gl_ObjectRayDirectionEXT;
  //debugPrintfEXT("ray id: %d, rayDir: (%f, %f, %f), depth: %d\n", prd.ray_id, rayDir.x, rayDir.y, rayDir.z, prd.recursionDepth);

  float cos1 = -dot(rayDir, out_normal);

  float n_ij = 1.5f;
  float cos2 = sqrt((n_ij * n_ij) - (1.0 - cos1 * cos1)) / n_ij;

  float u1 = 1.0f;
  float u2 = 2.0f;

  float Rv = (u2 * n_ij * cos1 - u1 * cos2) / (u2 * n_ij * n_ij * cos1 + u1 * cos2);

  // updating ref_idx
  float Rv_total = prd.ref_idx + Rv;
  prd.ref_idx = Rv_total;

  // ray tracing (reflection)
  vec3 hit_point = gl_ObjectRayOriginEXT + gl_RayTmaxEXT * rayDir;
  vec3 reflect_dir = reflect(rayDir, out_normal);
  //debugPrintfEXT("depth: %d, ray id: %d, rayDir: (%f, %f, %f), out_normal: (%f, %f, %f), reflect_dir: (%f, %f, %f)\n",
  //               prd.recursionDepth, prd.ray_id, rayDir.x, rayDir.y, rayDir.z, out_normal.x, out_normal.y, out_normal.z, reflect_dir.x, reflect_dir.y, reflect_dir.z);
  //debugPrintfEXT("depth: %d, ray id: %d, origin: (%f, %f, %f), tmax: %f, rayDir: (%f, %f, %f)\n",
  //              prd.recursionDepth, prd.ray_id, gl_ObjectRayOriginEXT.x, gl_ObjectRayOriginEXT.y, gl_ObjectRayOriginEXT.z,
  //              gl_RayTmaxEXT, rayDir.x, rayDir.y, rayDir.z);
  //debugPrintfEXT("ray id: %d, hit_point: (%f, %f, %f)\n", prd.ray_id, hit_point.x, hit_point.y, hit_point.z);
  float tMin = 1e-5;
  float tMax = 20000.0f;
  uint flags = gl_RayFlagsOpaqueEXT;

  // updating recursion depth
  prd.recursionDepth++;
  
 if (prd.recursionDepth < MAX_RECURSION_DEPTH) {
    //debugPrintfEXT("prd: %d, %f, %f, %f, depth: %d\n", prd.ray_id, prd.tpath, prd.ref_idx, prd.receive, prd.recursionDepth);

    traceRayEXT(topLevelAS,     // acceleration structure
                flags,          // rayFlags
                0xFF,           // cullMask
                0,              // sbtRecordOffset
                0,              // sbtRecordStride
                1,              // missIndex
                hit_point,      // ray origin
                tMin,           // ray min range
                reflect_dir,         // ray direction
                tMax,           // ray max range
                0               // payload (location = 1)
              );
    }
  
}

/*
void main()
{
  // Object data
  ObjDesc    objResource = objDesc.i[gl_InstanceCustomIndexEXT];
  MatIndices matIndices  = MatIndices(objResource.materialIndexAddress);
  Materials  materials   = Materials(objResource.materialAddress);
  Indices    indices     = Indices(objResource.indexAddress);
  Vertices   vertices    = Vertices(objResource.vertexAddress);

  // Indices of the triangle
  ivec3 ind = indices.i[gl_PrimitiveID];

  // Vertex of the triangle
  Vertex v0 = vertices.v[ind.x];
  Vertex v1 = vertices.v[ind.y];
  Vertex v2 = vertices.v[ind.z];

  const vec3 barycentrics = vec3(1.0 - attribs.x - attribs.y, attribs.x, attribs.y);

  // Computing the coordinates of the hit position
  const vec3 pos      = v0.pos * barycentrics.x + v1.pos * barycentrics.y + v2.pos * barycentrics.z;
  const vec3 worldPos = vec3(gl_ObjectToWorldEXT * vec4(pos, 1.0));  // Transforming the position to world space

  // Computing the normal at hit position
  const vec3 nrm      = v0.nrm * barycentrics.x + v1.nrm * barycentrics.y + v2.nrm * barycentrics.z;
  const vec3 worldNrm = normalize(vec3(nrm * gl_WorldToObjectEXT));  // Transforming the normal to world space

  // Vector toward the light
  vec3  L;
  float lightIntensity = pcRay.lightIntensity;
  float lightDistance  = 100000.0;
  // Point light
  if(pcRay.lightType == 0)
  {
    vec3 lDir      = pcRay.lightPosition - worldPos;
    lightDistance  = length(lDir);
    lightIntensity = pcRay.lightIntensity / (lightDistance * lightDistance);
    L              = normalize(lDir);
  }
  else  // Directional light
  {
    L = normalize(pcRay.lightPosition);
  }

  // Material of the object
  int               matIdx = matIndices.i[gl_PrimitiveID];
  WaveFrontMaterial mat    = materials.m[matIdx];


  // Diffuse
  vec3 diffuse = computeDiffuse(mat, L, worldNrm);
  if(mat.textureId >= 0)
  {
    uint txtId    = mat.textureId + objDesc.i[gl_InstanceCustomIndexEXT].txtOffset;
    vec2 texCoord = v0.texCoord * barycentrics.x + v1.texCoord * barycentrics.y + v2.texCoord * barycentrics.z;
    diffuse *= texture(textureSamplers[nonuniformEXT(txtId)], texCoord).xyz;
  }

  vec3  specular    = vec3(0);
  float attenuation = 1;

  // Tracing shadow ray only if the light is visible from the surface
  if(dot(worldNrm, L) > 0)
  {
    float tMin   = 0.001;
    float tMax   = lightDistance;
    vec3  origin = gl_WorldRayOriginEXT + gl_WorldRayDirectionEXT * gl_HitTEXT;
    vec3  rayDir = L;
    uint  flags  = gl_RayFlagsTerminateOnFirstHitEXT | gl_RayFlagsOpaqueEXT | gl_RayFlagsSkipClosestHitShaderEXT;
    isShadowed   = true;
    traceRayEXT(topLevelAS,  // acceleration structure
                flags,       // rayFlags
                0xFF,        // cullMask
                0,           // sbtRecordOffset
                0,           // sbtRecordStride
                1,           // missIndex
                origin,      // ray origin
                tMin,        // ray min range
                rayDir,      // ray direction
                tMax,        // ray max range
                1            // payload (location = 1)
    );

    if(isShadowed)
    {
      attenuation = 0.3;
    }
    else
    {
      // Specular
      specular = computeSpecular(mat, gl_WorldRayDirectionEXT, L, worldNrm);
    }
  }

  prdOut = prd;
}
*/
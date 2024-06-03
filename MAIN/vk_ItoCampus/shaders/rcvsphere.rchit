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

#extension GL_EXT_debug_printf : enable

#include "raycommon.glsl"
#include "wavefront.glsl"

hitAttributeEXT vec2 attribs;

// clang-format off
layout(location = 0) rayPayloadInEXT hitPayload prd;
//layout(location = 1) rayPayloadEXT hitPayload prdOut;

layout(buffer_reference, scalar) buffer Vertices {Vertex v[]; }; // Positions of an object
layout(buffer_reference, scalar) buffer Indices {uint i[]; }; // Triangle indices
layout(buffer_reference, scalar) buffer Materials {WaveFrontMaterial m[]; }; // Array of all materials on an object
layout(buffer_reference, scalar) buffer MatIndices {int i[]; }; // Material ID for each triangle

layout(set = 0, binding = eTlas) uniform accelerationStructureEXT topLevelAS;
layout(set = 1, binding = eObjDescs, scalar) buffer ObjDesc_ { ObjDesc i[]; } objDesc;
layout(set = 1, binding = eTextures) uniform sampler2D textureSamplers[];
layout(set = 1, binding = eImplicit, scalar) buffer allSpheres_ {Sphere i[];} allSpheres;

layout(push_constant) uniform _PushConstantRay { PushConstantRay pcRay; };
// clang-format on



void main()
{
  //debugPrintfEXT("ray id: %d, depth: %d\n", prd.ray_id, prd.recursionDepth);
  // Object data
  ObjDesc    objResource = objDesc.i[gl_InstanceCustomIndexEXT];
  MatIndices matIndices  = MatIndices(objResource.materialIndexAddress);
  Materials  materials   = Materials(objResource.materialAddress);

  vec3 worldPos = gl_WorldRayOriginEXT + gl_WorldRayDirectionEXT * gl_HitTEXT;

  Sphere instance = allSpheres.i[gl_PrimitiveID];

  // Computing the normal at hit position
  vec3 worldNrm = normalize(worldPos - instance.center);

  // updating total path length & recursion depth
  float total_path_length = gl_RayTmaxEXT + prd.tpath;
  prd.tpath = total_path_length;

  if (prd.ref_idx == 0.0f) {prd.ref_idx = 1.0f;}

  // Computing result
  float result = ((1.0f * 1.0f * 1.0f) / (16.0f * M_PIf * M_PIf)) * (prd.ref_idx/total_path_length);
  prd.receive = result;

  debugPrintfEXT("ray ID: %d, result: %f, total path: %f, depth: %d\n", prd.ray_id, prd.receive, prd.tpath, prd.recursionDepth);
}

//
//  Shaders.metal
//  ChessBoxing
//
//  Created by NathanSpaun on 6/19/23.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "ShaderTypes.h"

using namespace metal;

struct VertexOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant VertexUniforms &uniforms [[buffer(1)]])
{
    Vertex in = vertexArray[vid];
    VertexOut out;
    
    out.color = in.color;
    
    simd_float4 camera_pos = uniforms.camera_transform * in.pos;
    
    float viewport_x = camera_pos.x * uniforms.projection_plane_z / camera_pos.z;
    float viewport_y = camera_pos.y * uniforms.projection_plane_z / camera_pos.z;
    
    float project_x = viewport_x / uniforms.viewport_size;
    
    float project_y = viewport_y / uniforms.viewport_size;

    float4 position = float4(project_x, project_y, camera_pos.z/10, 1.0);
    out.pos = position;

    return out;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]], constant FragmentUniforms &uniforms [[buffer(0)]])
{
    return float4(uniforms.brightness * interpolated.color.rgb, interpolated.color.a);
}

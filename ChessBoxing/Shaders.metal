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


/**
 var ViewportToCanvas = function(p2d) {
   return Pt(p2d.x * canvas.width / viewport_size,
         p2d.y * canvas.height / viewport_size);
 }


 var ProjectVertex = function(v) {
   return ViewportToCanvas(Pt(v.x * projection_plane_z / v.z,
                  v.y * projection_plane_z / v.z));
 }

 */
vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant VertexUniforms &uniforms [[buffer(1)]])
{
    Vertex in = vertexArray[vid];
    VertexOut out;
    
    out.color = in.color;
    
    
    float viewport_x = in.pos.x * uniforms.projection_plane_z / in.pos.z;
    float viewport_y = in.pos.y * uniforms.projection_plane_z / in.pos.z;
    
    float project_x = viewport_x / uniforms.viewport_size;
    
    float project_y = viewport_y / uniforms.viewport_size;
    
    

    float4 position = float4(project_x, project_y, 0, 1.0);
    out.pos = position;

    return out;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]], constant FragmentUniforms &uniforms [[buffer(0)]])
{
    return float4(uniforms.brightness * interpolated.color.rgb, interpolated.color.a);
}

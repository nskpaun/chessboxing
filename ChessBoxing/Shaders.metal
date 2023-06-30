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

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    Vertex in = vertexArray[vid];
    VertexOut out;
    
    out.color = in.color;

    float4 position = float4(in.pos.x, in.pos.y, 0, 1.0);
    out.pos = position;

    return out;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]])
{
    return interpolated.color;
}

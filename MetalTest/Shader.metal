//
//  Shader.metal
//  MetalTest
//
//  Created by MacBook Pro on 6/21/19.
//  Copyright © 2019 Borb. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
struct ModelConstants {
    float4x4 modelViewMatrix;
};

struct VertexIn
{
    float4 position[[attribute(0)]];
    float4 color[[attribute(1)]];
    float2 texture [[attribute(2)]];
};

struct VertexOut
{
    float4 position[[position]];
    float4 color;
    float2 texture;
};
                    
vertex VertexOut vertex_shader(const VertexIn vertexIn[[stage_in]],
                               constant ModelConstants &modeConst [[ buffer(1) ]] )
{
    VertexOut out;
    out.position = modeConst.modelViewMatrix * vertexIn.position;
    out.color = vertexIn.color;
    out.texture = vertexIn.texture;
    return out;
}

fragment half4 fragment_shader(VertexOut vertexIn [[stage_in]])
{
    return half4(vertexIn.color);
}
fragment half4 masked_textured_fragment_shader(VertexOut vertexIn [[stage_in]], texture2d<float> texture [[texture(0)]],texture2d<float> textureMask [[texture(1)]])
{
    constexpr sampler defaultSampler;
    float a = textureMask.sample(defaultSampler, vertexIn.texture).a;
    float4 color = texture.sample(defaultSampler, vertexIn.texture) * vertexIn.color;
    return half4(color.r,color.g,color.b,color.a*a);
}

fragment half4 textured_fragment_shader(VertexOut vertexIn [[stage_in]], texture2d<float> texture [[texture(0)]])
{
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, vertexIn.texture) * vertexIn.color;
    return half4(color.r,color.g,color.b,color.a);
}


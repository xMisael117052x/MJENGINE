
//--------------------------------------------------------------------------------------
// File: ShadowTester.fx
//
// Se han definido dos pixel shaders: uno para el renderizado normal y otro para la sombra.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Variables de los constant buffers
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register(t0);
SamplerState samLinear : register(s0);

cbuffer cbNeverChanges : register(b0)
{
    matrix View;
};

cbuffer cbChangeOnResize : register(b1)
{
    matrix Projection;
};

cbuffer cbChangesEveryFrame : register(b2)
{
    matrix World;
    float4 vMeshColor;
};

//--------------------------------------------------------------------------------------
// Estructuras de entrada y salida para los shaders
//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD0;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT) 0;
    output.Pos = mul(input.Pos, World);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Tex = input.Tex;
    
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader para renderizado normal
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    return txDiffuse.Sample(samLinear, input.Tex) * vMeshColor;
}

//--------------------------------------------------------------------------------------
// Pixel Shader para la sombra (color oscuro y semitransparente)
//--------------------------------------------------------------------------------------
float4 ShadowPS(PS_INPUT input) : SV_Target
{
    return float4(0.0f, 0.0f, 0.0f, 0.5f);
}

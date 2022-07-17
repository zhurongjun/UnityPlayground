Shader "PlayGround/TestNoise"
{
    Properties {}
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Include/Noise.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityWorldToClipPos(o.worldPos);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // return goldNoise34(floor(i.worldPos * 10) + 0.1f);
                // return perlinNoise34(i.worldPos / 10, 10);
                // return voronoiNoise24(i.worldPos.xz / 10, 10);
                // return perlinNoise21(i.worldPos.xz / 10, 10);
                // return voronoiNoise34(i.worldPos / 10, 10);
                // return voronoiNoiseInv21(i.worldPos.xz / 10, 10);
                // return voronoiNoiseInv31(i.worldPos / 10, 10);
                return voronoiNoiseInv34(i.worldPos / 10, 10);
            }
            ENDCG
        }
    }
}
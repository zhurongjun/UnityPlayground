Shader "PlayGround/Auroras"
{
    Properties
    {
        _AurorasColor ("极光颜色", Color) = (0.4, 0.4, 0.4, 1)
        _AurorasIntensity("极光强度", Range(0.1, 20)) = 3
        _AurorasTiling("极光平铺", Range(0.1, 10)) = 0.4
        _AurorasSpeed ("极光变化速度", Range(0.01, 1)) = 0.1
        _AurorasAttenuation("极光衰减", Range(0, 0.99)) = 0.4
        _SkyCurvature ("天空曲率", Range(0, 10)) = 0.4
        _RayMarchDistance("步进距离", Range(0.01, 1)) = 2.5
        [IntRange] _RayMarchStep("步进步数", Range(1,128)) = 64
        _SkyLineSize("天际线大小", Range(0, 1)) = 0.06
        _SkyLineBasePow("天际线基础强度", Range(0, 1)) = 0.1
    }
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
            #include "AurorasHelp.hlsl"

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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(v.vertex, unity_ObjectToWorld);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            float3 _AurorasColor;
            float _AurorasIntensity;
            float _AurorasTiling;
            float _AurorasSpeed;
            float _AurorasAttenuation;
            float _SkyCurvature;
            float _RayMarchDistance;
            float _RayMarchStep;
            float _SkyLineSize;
            float _SkyLineBasePow;

            fixed4 frag (v2f i) : SV_Target
            {
                // 计算ray march信息
                float3 rayOriginal = 0;
                float3 totalDir = i.worldPos - rayOriginal;
                float3 rayDir = normalize(totalDir);
                if (rayDir.y < 0) discard;

                // 拓展球面来计算march的起始点
                float skyCurvatureFactor = rcp(rayDir.y + _SkyCurvature);
                float3 basicRayPlane = rayDir * _AurorasTiling * skyCurvatureFactor;
                float3 rayMarchBegin = rayOriginal + basicRayPlane;

                // ray march
                float3 color = 0;
                float3 avgColor = 0;
                float stepSize = rcp(_RayMarchStep);
                for (float i = 0; i < _RayMarchStep; i += 1)
                {
                    float curStep = stepSize * i;
                    // 初始的几次采样贡献更大, 我们用二次函数着重初始采样
                    curStep = curStep * curStep;
                    float curDistance = curStep * _RayMarchDistance;
                    float3 curPos = rayMarchBegin + rayDir * curDistance * skyCurvatureFactor;

                    // 采样当前的噪声强度
                    float curNoise = saturate(rcp(aurorasNoise2(curPos.xz, _Time.y * _AurorasSpeed) * 50) - 0.1f) / 0.9f;

                    // 强度衰减
                    curNoise = curNoise * saturate(1 - pow(curDistance, 1 - _AurorasAttenuation));

                    // 色彩计算
                    float3 curColor = sin((_AurorasColor * 2 - 1) + i * 0.043) * 0.5 + 0.5;
                    avgColor = (avgColor + curColor) / 2;

                    // 混合颜色
                    color += avgColor * curNoise * stepSize;
                }

                // 强度
                color *= _AurorasIntensity;

                // 混合天际线
                color *= saturate(rayDir.y / _SkyLineSize + _SkyLineBasePow);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
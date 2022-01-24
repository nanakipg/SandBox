Shader "Custom/DitherMask"
{
    Properties
    {
        _Alpha ("Alpha", Range(0.0, 1.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #pragma target 3.0
            
           #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };
            
            struct v2f
            {
            };

            sampler3D _DitherMaskLOD;
            half _Alpha;
            
            v2f vert (appdata v, out float4 vertex : SV_POSITION)
            {
                v2f o;
                vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            fixed4 frag (v2f i, UNITY_VPOS_TYPE vpos : VPOS) : SV_Target
            {
                // 4px x 4pxのブロック毎にテクスチャをマッピングする
                vpos *= 0.25;

                // ディザ用テクスチャは4px x 4px x 16px
                clip(tex3D(_DitherMaskLOD, float3(vpos.xy, _Alpha * 0.9375)).a - 0.5);
                return 1;
            }
            ENDCG
        }
    }
}
Shader "Custom/FakeRadialBlur" {
    CGINCLUDE
    #include "UnityCG.cginc"
    struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
    };
    struct v2f {
        float4 vertex : SV_POSITION;
        float2 uv : TEXCOORD0;
    };
    float _Intensity;           // Strength of the radial effect
    float _FadeRadius;          // Fade out the radius of the radial effect
    float _SampleDistance;      // The distance of each sample
    sampler2D _DownSampleRT;    // The original image after downsampling
    sampler2D _SrcTex;          // Original image texture
    v2f vert(appdata v) {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;
        return o;
    }
    fixed4 frag(v2f i) : SV_Target {
        const int sampleCount = 5; // Just think about the number of samples, multiplied by 2 is the true total number of times
        const float invSampleCount = 1.0 / ((float)sampleCount * 2);
        float2 vec = i.uv - 0.5;
        float len = length(vec);
        float fade = smoothstep(0, _FadeRadius, len); // Smoothly fade out the radial effect value
        float2 stepDir = normalize(vec) * _SampleDistance; // Each sampling step direction
        float stepLenFactor = len * 0.1 * _Intensity; // len: 0~0.5 multiplied by 0.1 is 0~0.05. The closer to the center, the smaller the sampling distance and the smaller the ambiguity relative to the edge
        stepDir *= stepLenFactor; // Control the step length value, stepLenFactor=len * 0.1 * _Intensity: 0.1 is the empirical value can be ignored, or external public control is also possible
        fixed4 sum = 0;
        for (int it = 0; it < sampleCount; it++) {
            float2 appliedStep = stepDir * it;
            sum += tex2D(_DownSampleRT, i.uv + appliedStep); // Forward sampling
            sum += tex2D(_DownSampleRT, i.uv - appliedStep); // reverse sampling
        }
        sum *= invSampleCount; // The mean is blurred
        return lerp(tex2D(_SrcTex, i.uv), sum, fade * _Intensity);
    }
    ENDCG
    SubShader {
        Cull Off ZWrite Off ZTest Always
        Pass {
            NAME "RADIA_BLUR"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
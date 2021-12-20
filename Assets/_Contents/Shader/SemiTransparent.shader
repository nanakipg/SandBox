Shader "Custom/SemiTransparent"
{
	Properties
    {
		_Color("Color", Color) = (1,1,1,1)
    	_Alpha("Alpha", float) = 1
    }
   	SubShader {
		Tags { "Queue" = "Transparent" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard alpha:fade 
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		fixed  _Alpha;
		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo =  _Color;
			o.Alpha = _Alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"

}

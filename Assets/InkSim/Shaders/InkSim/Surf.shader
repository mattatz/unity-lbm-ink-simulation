Shader "InkSim/Surf" {

	Properties {
		_Color ("Brush Color", Color) = (1, 0, 0, 1)
		_SurfTex ("Surface Texture", 2D) = "" {}
		_Mask ("Mask Texture", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
		_Omega ("omega", float) = 0.1
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform float4 _Color;
	uniform sampler2D _SurfTex;
	uniform sampler2D _Mask;
	uniform float4 _Mask_TexelSize;
	uniform float _Dx;
	uniform float _Dy;
	uniform float _Omega;
	
	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		
		float4 mask = tex2D(_Mask, uv);
		if(mask.r > 0) {
			return _Color;
		}
		
		float4 surf = tex2D(_SurfTex, uv);
		if(surf.a > 0.5) {
			// surf.a *= 0.0;
			// return surf;
		}
		return float4(0, 0, 0, 0);
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	
	} 
	
	FallBack "Diffuse"
}

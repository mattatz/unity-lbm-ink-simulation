Shader "InkSim/Fill" {

	Properties {
		_Color ("Color", Color) = (0, 0, 0, 0)
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform float4 _Color;
	
	float4 frag(v2f_img IN) : SV_Target {
		return _Color;
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

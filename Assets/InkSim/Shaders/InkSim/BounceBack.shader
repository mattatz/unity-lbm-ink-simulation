Shader "InkSim/BounceBack" {

	Properties {
		_Diffuse1 ("Diffuse Texture 1", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture 2", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture 3", 2D) = "" {}
		_Mask ("Mask Texture", 2D) = "black" {}
		_Strongness ("Strongness", float) = 1.1
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform sampler2D _Mask;
	uniform float _Strongness;

	// (W, NW, N)
	float4 bounceback1(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > 0) {
			float4 v2 = tex2D(_Diffuse2, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			col = float4(v2.g, v2.b, v3.r, 1.);
			col.rgb *= _Strongness;
		} else {
			col = tex2D(_Diffuse1, IN.uv);
		}
		return col;
	}
	
	float4 bounceback2(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > 0) {
			float4 v1 = tex2D(_Diffuse1, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			col = float4(v3.g, v1.r, v1.g, 1.);
			col.rgb *= _Strongness;
		} else {
			col = tex2D(_Diffuse2, IN.uv);
		}
		return col;
	}
	
	float4 bounceback3(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > 0) {
			float4 v1 = tex2D(_Diffuse1, IN.uv);
			float4 v2 = tex2D(_Diffuse2, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			col = float4(v1.b, v2.r, v3.b, 1.);
			col.rgb *= _Strongness;
		} else {
			col = tex2D(_Diffuse3, IN.uv);
		}
		return col;
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback1
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback2
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback3
			ENDCG
		}
	
	} 
	
}

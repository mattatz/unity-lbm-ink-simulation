Shader "InkSim/Debug" {

	Properties {
		_MainTex ("Main Texture", 2D) = "" {}
		_Diffuse1 ("Diffuse Texture 1", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture 2", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture 3", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform float _Dx;
	uniform float _Dy;
	
	void velocity (float4 v1, float4 v2, float4 v3, out float u, out float v) {
		u = (v1.r + v1.g + v3.g) - (v2.r + v2.g + v2.b);
		v = (v1.g + v1.b + v2.r) - (v2.b + v3.r + v3.g);
	}

	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		float4 eses = tex2D(_Diffuse1, uv);
		float4 swwnw = tex2D(_Diffuse2, uv);
		float4 nnec = tex2D(_Diffuse3, uv);
	
		float hr = eses.x + eses.y + swwnw.x + swwnw.y + swwnw.z + nnec.y;
		float vt = eses.y + eses.z + swwnw.x + swwnw.z + nnec.x + nnec.y;
		float2 v = float2(hr, vt);
		return float4(v, 0, 1);
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	
	} 
	
}

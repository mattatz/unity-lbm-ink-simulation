Shader "InkSim/Flow" {

	Properties {
		_SurfTex ("Surface Texture", 2D) = "" {}
		_FlowTex ("Flow Texture", 2D) = "" {}
		_FixtureTex ("Fixture Texture", 2D) = "" {}
		_Diffuse1 ("Diffuse Texture", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
		_Omega ("Omega", float) = 0.85
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _SurfTex;
	uniform sampler2D _FlowTex;
	uniform sampler2D _FixtureTex;
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform float _Dx;
	uniform float _Dy;
	uniform float _Omega;
	
	void velocity (float4 tex1, float4 tex2, float4 tex3, out float u, out float v) {
		u = (tex1.r + tex1.g + tex3.g) - (tex2.r + tex2.g + tex2.b);
		v = (tex1.g + tex1.b + tex2.r) - (tex2.b + tex3.r + tex3.g);
	}
	
	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		
		float4 v1 = tex2D(_Diffuse1, uv);
		float4 v2 = tex2D(_Diffuse2, uv);
		float4 v3 = tex2D(_Diffuse3, uv);
		float ux, uy;
		
		velocity(v1, v2, v3, ux, uy);
		
		float2 offset = float2(clamp(ux, -_Dx, _Dx), clamp(uy, -_Dy, _Dy));
		
		float4 flowFrom = tex2D(_FlowTex, uv);
		float4 flowTo = tex2D(_FlowTex, uv + offset);
		float4 flow = lerp(flowFrom, flowTo, 0.9);
		float4 fix = tex2D(_FixtureTex, uv + offset);
		
		float4 surf = tex2D(_SurfTex, uv);
		return lerp(surf, lerp(flow, fix, 0.3), _Omega);
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
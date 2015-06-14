Shader "InkSim/Fixture" {

	Properties {
		_SurfTex ("Surface Texture", 2D) = "" {}
		_FlowTex ("Flow Texture", 2D) = "" {}
		_FixtureTex ("Fixture Texture", 2D) = "" {}
		_Fade ("Fade", float) = 0.995
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _SurfTex;
	uniform sampler2D _FlowTex;
	uniform sampler2D _FixtureTex;
	uniform float _Fade;
	uniform float _Dx;
	uniform float _Dy;

	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
	
		float4 surf = tex2D(_SurfTex, uv);
		float4 flow = tex2D(_FlowTex, uv);
		float4 fix = tex2D(_FixtureTex, uv);
		return float4(
			max(fix.r, flow.r),
			max(fix.g, flow.g),
			max(fix.b, flow.b),
			max(fix.a, flow.a)
		) * _Fade;
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
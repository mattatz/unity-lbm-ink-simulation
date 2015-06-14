Shader "InkSim/Show" {

	Properties {
		_MainTex ("Main Texture", 2D) = "" {}
		_SurfTex ("Surface Texture", 2D) = "" {}
		_FlowTex ("Flow Texture", 2D) = "" {}
		_FixtureTex ("Fixture Texture", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	uniform sampler2D _SurfTex;
	uniform sampler2D _FlowTex;
	uniform sampler2D _FixtureTex;
	
	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		float4 bg = tex2D(_MainTex, uv);
		
		// uv.y = uv.y * -1;
		float4 surf = tex2D(_SurfTex, uv);
		float4 flow = tex2D(_FlowTex, uv);
		float4 fixture = tex2D(_FixtureTex, uv);
		// float4 c = flow + fixture;
		float4 c = fixture;
		return lerp(bg, c, c.a);
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

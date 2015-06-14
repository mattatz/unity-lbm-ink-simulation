Shader "InkSim/Compute" {

	Properties {
		_Diffuse1 ("Diffuse Texture 1", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture 2", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture 3", 2D) = "" {}
		_DisorderTex ("Disorder Texture", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
		__Omega ("_Omega", float) = 0.1
		_T ("time", float) = 0.0
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform sampler2D _DisorderTex;
	uniform float _Omega;
	uniform float _Dx;
	uniform float _Dy;
	uniform float _T;

	float4 compute1 (v2f_img IN) : SV_Target {
	
		#include "Includes/compute.cginc"

		float feq1 = t2 * density * (1. + ux / c_squ + 0.5 * (ux / c_squ) * (ux / c_squ)- usqu / (2. * c_squ));
		float feq3 = t2 * density * (1. + uy / c_squ + 0.5 * (uy / c_squ) * (uy / c_squ) - usqu / (2. * c_squ));
		float feq2 = t3 * density * (1. + uc2 / c_squ + 0.5 * (uc2 / c_squ) * (uc2 / c_squ)- usqu / (2. * c_squ));
		
		float omega = _Omega * tex2D(_DisorderTex, uv).x;
		
		float ff1 = omega * feq1 + (1.0 - omega) * f1;
		float ff2 = omega * feq2 + (1.0 - omega) * f2;
		float ff3 = omega * feq3 + (1.0 - omega) * f3;
		
		ff1 = clamp(ff1, 0.0, 1.0);
		ff2 = clamp(ff2, 0.0, 1.0);
		ff3 = clamp(ff3, 0.0, 1.0);
		
		return float4(ff1, ff2, ff3, 1.0);
	}
	
	float4 compute2(v2f_img IN) : SV_Target {
	
		#include "Includes/compute.cginc"
		
		float feq5 = t2 * density * (1. - ux / c_squ + 0.5 * (ux / c_squ) * (ux / c_squ) - usqu / (2. * c_squ));
		float feq4 = t3 * density * (1. + uc4 / c_squ + 0.5 * (uc4 / c_squ) * (uc4 / c_squ) - usqu / (2. * c_squ));
		float feq6 = t3 * density * (1. + uc6 / c_squ + 0.5 * (uc6 / c_squ) * (uc6 / c_squ) - usqu / (2. * c_squ));
		
		float omega = _Omega * tex2D(_DisorderTex, uv).x;
				
		float ff4 = omega * feq4 + (1. - omega) * f4;
		float ff5 = omega * feq5 + (1. - omega) * f5;
		float ff6 = omega * feq6 + (1. - omega) * f6;				
		
		ff4 = clamp(ff4, 0.0, 1.0);
		ff5 = clamp(ff5, 0.0, 1.0);
		ff6 = clamp(ff6, 0.0, 1.0);

		return float4(ff4, ff5, ff6, 1.);
	}
	
	float4 compute3(v2f_img IN) : SV_Target {
	
		#include "Includes/Compute.cginc"

		float feq7 = t2 * density * (1. - uy / c_squ + 0.5 * (uy / c_squ) * (uy / c_squ) - usqu / (2. * c_squ));
		float feq8 = t3 * density * (1. + uc8 / c_squ + 0.5 * (uc8 / c_squ) * (uc8 / c_squ) - usqu / (2. * c_squ));
		float feq9 = t1 * density * (1. - usqu / (2. * c_squ));
		
		float omega = _Omega * tex2D(_DisorderTex, uv).x;
		
		float ff7 = omega * feq7 + (1. - omega) * f7;
		float ff8 = omega * feq8 + (1. - omega) * f8;
		float ff9 = omega * feq9 + (1. - omega) * f9;				
		
		ff7 = clamp(ff7, 0.0, 1.0);
		ff8 = clamp(ff8, 0.0, 1.0);
		ff9 = clamp(ff9, 0.0, 1.0);
		
		return float4(ff7, ff8, ff9, 1.);
	}
	
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment compute1
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment compute2
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment compute3
			ENDCG
		}
		
	} 
	
	FallBack "Diffuse"
}

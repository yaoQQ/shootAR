// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Particles/Additive-MaskBland" {
Properties {
	_Color("Main Color",Color) = (1,1,1,1)
	_MainTex ("Main Tex", 2D) = "white" {}
	_MaskTex ("Mask Tex (RGB)", 2D) = "white" {}
	_AMultiplier ("Layer Multiplier", Float) = 0.5
	_Bland ("Bland", Range(0,1)) = 1
}

SubShader {
	Tags {"Queue"="Transparent" "RenderType"="Transparent" }
	
	Blend One One
	ZWrite Off	
	Lighting Off Fog { Mode Off }
	LOD 100
	
		
	CGINCLUDE
	#include "UnityCG.cginc"
	
	sampler2D _MainTex;
	sampler2D _MaskTex;

	float4 _MainTex_ST;
	float4 _MaskTex_ST;
	
	float _AMultiplier;
	
	float4 _Color;
	half _Bland;

	
	
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 MainTex : TEXCOORD0;
		float2 MaskTex : TEXCOORD1;
		float4 color : TEXCOORD2;		
	};

	
	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		
		o.MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.MaskTex = TRANSFORM_TEX(v.texcoord, _MaskTex);
		
		o.color = v.color * _Color * _Color.a;
		o.color.xyz *= _AMultiplier;

		return o;
	}
	ENDCG


	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest		
		fixed4 frag (v2f i) : COLOR
		{
			fixed4 o;
			fixed4 tex = tex2D (_MainTex, i.MainTex);
			fixed4 tex2 = tex2D (_MaskTex, i.MaskTex) ;
			
			o = lerp( tex * tex2, tex, _Bland) * i.color;
			
			return o;
		}
		ENDCG 
	}	
}
}

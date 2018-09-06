// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Ship-Ill_RimLight" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Rim Color", Color) =(0,0,0,1)
		_Outline ("Rim width", Range(.002,0.03)) = 0.00001
		_MainText("Base (RGB)",2D)="White"{}
		_Illum("Illumin (A)",2D)="White"{}
		_EmissionLM("Emission (Lightmapper)",Float)=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		sampler2D _MainText;
	    sampler2D _Illum;
		fixed4 _Color;

		struct Input{
		float2 uv_MainText;
		float2 uv_Illum;
		};

		void surf(Input IN,inout SurfaceOutput o){
		fixed4 tex=tex2D(_MainText,IN.uv_MainText);
		fixed4 c=tex *_Color;
        o.Albedo = c.rgb;
             o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a;
             o.Alpha = c.a;
         }
         ENDCG
 
         Pass 
         {
             CGINCLUDE
             #include "UnityCG.cginc"
     
             struct appdata {
                 float4 vertex : POSITION;
                 float3 normal : NORMAL;
             };
 
             struct v2f {
                 float4 pos : POSITION;
                 float4 color : COLOR;
             };
     
             uniform float _Outline;
             uniform float4 _OutlineColor;
     
             v2f vert(appdata v) {
                 v2f o;
                 o.pos = UnityObjectToClipPos(v.vertex);
 
                 float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                 float2 offset = TransformViewToProjection(norm.xy);
 
                 o.pos.xy += offset * o.pos.z * _Outline;
                 o.color = _OutlineColor;
                 return o;
             }
             ENDCG
 
             Name "OUTLINE"
             Tags { "LightMode" = "Always" }
             Cull Front
             ZWrite On
             ColorMask RGB
             Blend SrcAlpha OneMinusSrcAlpha
 
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             half4 frag(v2f i) :COLOR { return i.color; }
             ENDCG
         }
     } 
     
     Fallback "Self-Illumin/VertexLit"
 }

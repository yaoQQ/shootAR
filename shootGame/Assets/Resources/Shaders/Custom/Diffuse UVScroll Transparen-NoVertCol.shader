Shader "Custom/Environment/Diffuse UVScroll Transparent - No Vert Color" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_lmIndensity("LM Indensity", Float) = 1
	_ColorX ("Offset (RGB) x", Float) = 0
	_ColorY ("Offset (RGB) y", Float) = 0
	_AlphaX ("Offset (A) x", Float) = 0
	_AlphaY ("Offset (A) y", Float) = 0
}

SubShader {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	LOD 200
	Lighting Off 
	//Fog { Mode Exp2 Density 0 }
	ZWrite Off
	//Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
	//Blend One One // Additive
	Blend OneMinusDstColor One // Soft Additive
	//Blend DstColor Zero // Multiplicative
	//Blend DstColor SrcColor // 2x Multiplicative
	

CGPROGRAM
#pragma surface surf Lambert nofog noforwardadd novertexlights
#pragma target 3.0

sampler2D _MainTex;
fixed4 _Color;
float _ColorX;
float _ColorY;
float _AlphaX;
float _AlphaY;
float _lmIndensity;

struct Input {
	float2 uv_MainTex;
	float4 color : COLOR; //<Vertex Color HERE!
};


void surf (Input IN, inout SurfaceOutput o) {

	fixed moveTime1X = _Time * _ColorX;
	fixed moveTime1Y = _Time * _ColorY;
	fixed moveTime2X = _Time * _AlphaX;
	fixed moveTime2Y = _Time * _AlphaY;
	
	
	fixed2 ColorOffset = fixed2( IN.uv_MainTex.x+ moveTime1X, IN.uv_MainTex.y + moveTime1Y );
	fixed2 AlphaOffset = fixed2( IN.uv_MainTex.x+ moveTime2X, IN.uv_MainTex.y + moveTime2Y );
	
	fixed4 c = tex2D(_MainTex, ColorOffset.xy) * 1 * _Color;
	fixed4 TexA = tex2D(_MainTex, AlphaOffset.xy).a;
	
	o.Albedo = c.rgb * TexA * _lmIndensity;
	o.Alpha = c.a;
}
ENDCG
}
//Fallback "VertexLit"
}

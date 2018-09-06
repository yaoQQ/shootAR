Shader "Custom/Ship/SpeIllum" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.08
	_MainTex ("Base", 2D) = "white" {}
	_Filter("Filter Ref(R)Gloss(G)Ill(B)", 2D) = "white" {}
	_IlluminColor ("Illumin Color", Color) = (1,1,1,1)
	_Illumin ("Illumin", 2D) = "white" {}
	_IllIntensity ("Illumin-Intensity", Range (1,10)) = 1
	_DamageTex  ("Damage", 2D) = "white" {}
	_DamageAmount("Damage Amount", Range(0,1)) = 1
	_RimColor ("Rim Color", Color) = (0,0,0,0.0)
    _RimPower ("Rim Power", Range(0.5,8.0)) = 1.0
    _DisintegrateTex  ("Disintegrate", 2D) = "white" {}
    _EdgeColor("Edge Color", Color) = (1.0,0.5,0.2,0.0)
    _EdgeRange("Edge Range",Range(0.0,0.1)) = 0.002
	_DisintegrateAmount("Disintegrate Amount", Range(-1.0,1.0)) = 0
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 400

CGPROGRAM
#pragma surface surf BlinnPhong addshadow

	fixed4 _Color;
	sampler2D _MainTex;
	sampler2D _Filter;
	fixed4 _IlluminColor;
	sampler2D _Illumin;
	half _IllIntensity;
	half _Shininess;
	sampler2D _DamageTex;
	float  _DamageAmount;
	float4 _RimColor;
    float _RimPower;
    sampler2D _DisintegrateTex;
    float4 _EdgeColor;
    half  _DisintegrateAmount;
    half  _EdgeRange;
	

struct Input {
	float2 uv_MainTex;
	INTERNAL_DATA
    float3 viewDir;
    float3 worldPos;
    float3 worldNormal;
    float2 uv2_DisintegrateTex;
};

void surf (Input IN, inout SurfaceOutput o) {

	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	
	fixed4 d = tex2D(_DamageTex, IN.uv_MainTex);

	float clipval = (tex2D (_DisintegrateTex, IN.uv2_DisintegrateTex).rgb *  normalize(_DisintegrateAmount)) - _DisintegrateAmount;
	
	clip(clipval);
	
	if (clipval < _EdgeRange )
	{
		o.Albedo = _EdgeColor;
    }
    else    
    {
		o.Albedo = lerp(c*d, c, _DamageAmount);
	}
	fixed4 f = tex2D(_Filter, IN.uv_MainTex);
	fixed4 i = tex2D(_Illumin, IN.uv_MainTex) * _IlluminColor;

	o.Gloss = f.g ;
	o.Specular = _Shininess ;
	
	half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
	
	o.Emission = i.rgb * _IllIntensity * 2.5f * (f.b * f.b * f.b) + _RimColor.rgb * pow (rim, _RimPower);
	
	o.Alpha = c.a;

}
ENDCG
}
//FallBack "Legacy Shaders/Self-Illumin/Specular"
//CustomEditor "LegacyIlluminShaderGUI"
}

Shader "Custom/Ship/SpeIllumRefFlash-NoCube"
{
    Properties 
    {
	    _Color ("Main Color", Color) = (1,1,1,1)
	    _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	    _Shininess ("Shininess", Range (0.01, 1)) = 0.08
	    _MainTex ("Base", 2D) = "white" {}

	    _Intensity ("Intensity", Range (0,5)) = 1

	    _Filter("Filter Ref(R)Gloss(G)Ill(B)", 2D) = "white" {}
	    //_IlluminColor ("Illumin Color", Color) = (1,1,1,1)
	    //_Illumin ("Illumin", 2D) = "white" {}
	    //_IllIntensity ("Illumin-Intensity", Range (1,10)) = 1
	    //_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	    //_Cube ("Reflection Cubemap", Cube) = "" {}
	    //_RefIntensity ("Reflect-Intensity", Range (1,10)) = 1
	    //_RimColor ("Rim Color", Color) = (0,0,0,0.0)
        //_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0

        _FlashTex ("Flash map", 2D) = "white" {}
        _FlashPow ("Flash Pow", float) = 50.0
        _FlashTime ("Flash Time", float) = 100.0
    }

    SubShader 
    {
	    Tags { "RenderType"="Opaque" }
	    LOD 400

        CGPROGRAM
        #pragma surface surf BlinnPhong

	    fixed4 _Color;
	    sampler2D _MainTex;

	    fixed _Intensity;

	    sampler2D _Filter;
	    //fixed4 _IlluminColor;
	    //sampler2D _Illumin;
	    //half _IllIntensity;
	    half _Shininess;
	    //samplerCUBE _Cube;
	    //fixed4 _ReflectColor;
	    //half _RefIntensity;
	    //float4 _RimColor;
        //float _RimPower;

        sampler2D _FlashTex;
        float _FlashPow;
        float _FlashTime;
	

        struct Input 
        {
	        float2 uv_MainTex;
	        //float3 worldRefl;
	        //INTERNAL_DATA
            //float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o) 
        {
            float4 Flash = tex2D(_FlashTex, IN.uv_MainTex);
	        fixed vip = smoothstep(0.0,1.0,0.1);
	        vip += _Time * _FlashTime;

	        fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	        fixed4 c = tex * _Color;
	        o.Albedo = (c.rgb + c.rgb * (Flash * saturate(sin(vip))) * _FlashPow) * _Intensity;
	
	        fixed4 f = tex2D(_Filter, IN.uv_MainTex);
	        //fixed4 i = tex2D(_Illumin, IN.uv_MainTex) * _IlluminColor;
	
	        //float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	        //fixed4 reflcol = texCUBE (_Cube, worldRefl);
	        //reflcol *= f.r * f.r;

	        o.Gloss = f.g;
	        o.Specular = _Shininess;
	
	        //half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));

	        //o.Emission = _RimColor.rgb * pow (rim, _RimPower) +  reflcol.rgb * _ReflectColor.rgb * _RefIntensity +  i.rgb * _IllIntensity * 2.5f * (f.b * f.b * f.b) ;
	        o.Emission = 2.5f * (f.b * f.b * f.b) ;

	        o.Alpha = c.a;
        }
        ENDCG
    }
    //FallBack "Legacy Shaders/Self-Illumin/Specular"
    //CustomEditor "LegacyIlluminShaderGUI"
}
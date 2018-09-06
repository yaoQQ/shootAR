// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Environment/Planet_Illum_Rim_Glow_PointLight"
{
   Properties
   {
	  _Color ("Main Map Color", Color) = (1.0,1.0,1.0,1.0)
	  _MainTex ("Main Map(RGBA)", 2D) = "white" {}
	  _Indensity ("Main Map Indensity", Float) = 1.0
	  _AmbientIndensity ("Ambient Indensity", Float) = 1.0

	  _SpeMask ("Spe Mask Map", 2D) = "white" {}
	  _SpeColor ("Spe Color", Color) = (1,1,1,1)
	  _SpeRange ("Spe Range", float) = 20.0
	  _SpePow ("Spe Pow", float) = 1.0

	  _IllumColor ("Illumin Color", Color) = (1.0, 1.0, 1.0, 1.0)
	  _Illum ("Illumin Map(RGBA)", 2D) = "white" {}
	  _IlluminStrength ("Illumin Indensity", Float) = 1.0
	  _IllumOffsetX ("Illumin Offset x", Float) = 0.0
	  _IllumOffsetY ("Illumin Offset Y", Float) = 0.0

	  _RimColor ("Rim Color", Color) = (1.0,1.0,1.0,1.0)
	  _RimPower ("Rim Power", Range(0,1.0)) = 0.0
	  _RimIndensity ("Rim Indensity", Float) = 1.0

	  _GlowTex ("Glow Map(RGBA)", 2D) = "white" {}
	  _GlowIndensity ("Glow Map Indensity", Float) = 0.0
   }

   SubShader
   {

      Tags
	  {
	     "Queue"="Geometry"
	  }

	  LOD 300

	  Pass
	  {
	     Tags
	     {
            "LightMode"="ForwardBase"
	     }

		 CGPROGRAM
		 #pragma vertex vert
		 #pragma fragment frag
         #pragma multi_compile_fwdbase
         #pragma fragmentoption ARB_precision_hint_fastest
         #include "UnityCG.cginc"  
         #include "Lighting.cginc"  
         #include "AutoLight.cginc"

         fixed4 _Color;
         fixed4 _MainTex_ST;
         sampler2D _MainTex;
         fixed _Indensity;
         fixed _AmbientIndensity;

         sampler2D _SpeMask;
	     fixed4 _SpeColor;
	     fixed _SpeRange;
	     fixed _SpePow;

         fixed4 _IllumColor;
         sampler2D _Illum;
         fixed _IllumOffsetX;
         fixed _IllumOffsetY;
         fixed _IlluminStrength;

         fixed4 _RimColor;
         fixed _RimPower;
         fixed _RimIndensity;

         sampler2D _GlowTex;
         fixed _GlowIndensity;

         struct vertexInput
         {
             float4 vertex : POSITION;
             float3 normal : NORMAL;
             float2 texcoord: TEXCOORD0;
         };
            
         struct vertexOutput 
         {
             float4 pos : SV_POSITION;
             float4 posWorld : TEXCOORD0;
             float3 normalDir : TEXCOORD1;
             float3 vertexLighting : TEXCOORD2;
             float2 uv : TEXCOORD3;
         };
              
         vertexOutput vert(vertexInput input) 
         {  
                vertexOutput output;
                                                                
                output.pos = UnityObjectToClipPos(input.vertex);
                output.posWorld = mul(unity_ObjectToWorld, input.vertex);
                output.normalDir =  normalize(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz);

                output.vertexLighting = fixed3(0,0,0);//SH/ambient

                #ifdef LIGHTMAP_OFF
                fixed3 shLight = ShadeSH9 (fixed4(output.normalDir, 1.0));
                output.vertexLighting = shLight * _AmbientIndensity;
                #endif

                #ifdef VERTEXLIGHT_ON
                fixed3 vertexLight = Shade4PointLights
                (
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                    unity_4LightAtten0, output.posWorld, output.normalDir
                );
                output.vertexLighting += vertexLight;
                #endif

                vertexInput v = input;

                output.uv = TRANSFORM_TEX(input.texcoord, _MainTex);

                return output;
         }  
               
         fixed4 frag(vertexOutput input):COLOR
         {  
             fixed4 c = tex2D(_MainTex, input.uv) * _Color * _Indensity;

	         float moveTimeX = _Time * _IllumOffsetX;
	         float moveTimeY = _Time * _IllumOffsetY;
	         float2 texOffset = float2( input.uv.x+ moveTimeX, input.uv.y + moveTimeY );
	         float4 e = tex2D(_Illum, texOffset.xy) * _IlluminStrength * _IllumColor;
	         float4 f = tex2D(_Illum, input.uv);

	         fixed4 g = tex2D(_GlowTex, input.uv) * _GlowIndensity;
	         fixed4 j = tex2D(_SpeMask, input.uv);

             fixed3 lightDirection = normalize(input.vertexLighting);

             fixed3 normalDirection = normalize(input.normalDir);
             fixed3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);

             fixed3 h = normalize (lightDirection * -input.posWorld.xyz);
             fixed nh = saturate(max (0, dot (normalDirection, h)));
             fixed spec = saturate(pow (nh, _SpeRange));
             fixed3 specularReflection = spec * input.vertexLighting * _SpeColor.rgb * _SpePow * j;

             fixed4 light = fixed4(input.vertexLighting + specularReflection, 0.0);

             fixed rim = 1.0 - saturate(dot (normalize(viewDirection), input.normalDir));

             //float4 col = (c * light);
             float4 col = (c * light) + (((_RimColor * rim * _RimPower) * rim) * _RimIndensity) + (e * f.a * light);
             col.a = 0.0;

             return col + g;
         }
		 ENDCG		   
      }
   }
   //FallBack "Diffuse"
}
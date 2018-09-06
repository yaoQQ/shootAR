// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Particles/Additive-Blinking" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Particle Texture", 2D) = "white" {}
	_IntensityScaleBias ("Intensity scale X / bias Y", Vector) = (1,0.1,0,0)
	_SwitchOnOffDuration("Switch ON (X) / OFF (Y) duration", Vector) = (1,3,0,0)
	_Multiplier ("Multiplier", Float) = 2.0
	[HideInInspector]_BlinkingRate("Blinking rate",Float) = 0
	[HideInInspector]_RndGridSize("Randomization grid size",Float) = 0
	//_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend One One
	//AlphaTest Greater .01
	//ColorMask RGB
	Cull Off Lighting Off ZWrite Off
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			
			float4 _MainTex_ST;
			fixed4 _TintColor;
			float2 _IntensityScaleBias;
			float2 _SwitchOnOffDuration;
			float _BlinkingRate;	
			float _RndGridSize;
			float _Multiplier;
			
			struct appdata_t {
				float4 color : COLOR;
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				fixed4 color : COLOR;
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};
			
			float FakeNoise(float time,float seed)
			{
				return abs(cos(17 * sin(time * 5) +  10 * sin(seed + time * 3 + 7.993f)));
			}

			v2f vert (appdata_t v)
			{
				v2f o;
				
				float time = _Time.y;
				float seed = dot(v.color.xyzw,v.color.xyzw) * 40;
				float rnd = FakeNoise(time * _BlinkingRate,seed) > 0.5f;
				float2 swOnOff = _SwitchOnOffDuration * (0.8 + 0.4f * frac(seed));
				
				rnd *= fmod(_Time.y + seed,swOnOff.x + swOnOff.y) < swOnOff.x;
				
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.color = v.color * rnd * _IntensityScaleBias.x + _IntensityScaleBias.y;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			//sampler2D_float _CameraDepthTexture;
			//float _InvFade;
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D (_MainTex, i.uv);
				
				fixed4 col = tex * _Multiplier * i.color * _TintColor;
				col.rgb *= col.a;
				
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
				
				return col;
			}
			ENDCG 
		}
	}	
}
}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// 和 Stencil_plane  构成遮罩显示特效

Shader "Test/Additive-Z Test Always +Alpha_1" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Particle Texture", 2D) = "white" {}
	_AlphaTex ("Alpha (R)", 2D) = "white" {}
	//_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
	AlphaTest Greater .01
	ColorMask RGB
	Cull Off Lighting Off ZWrite Off ZTest Always
	
	SubShader {
		Pass {

				      Stencil {  
                Ref 1  
            Comp Equal  
                }  
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			fixed4 _TintColor;
			
			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				//#ifdef SOFTPARTICLES_ON
				//float4 projPos : TEXCOORD2;
				//#endif
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldPo1 = mul(unity_ObjectToWorld ,v.vertex);
				//#ifdef SOFTPARTICLES_ON
				//o.projPos = ComputeScreenPos (o.vertex);
				//COMPUTE_EYEDEPTH(o.projPos.z);
				//#endif
				o.color = v.color;
			//o.color  =(1* worldPo1.y *0.0001);
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			//sampler2D_float _CameraDepthTexture;
			//float _InvFade;
			
			fixed4 frag (v2f i) : SV_Target
			{
				//#ifdef SOFTPARTICLES_ON
				//float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
				//float partZ = i.projPos.z;
				//float fade = saturate (_InvFade * (sceneZ-partZ));
				//i.color.a *= fade;
				//#endif
				
				fixed4 col = 2.0f * i.color * _TintColor * tex2D(_MainTex, i.texcoord);
				fixed4 col2 = tex2D(_AlphaTex, i.texcoord) * _TintColor.a;
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
				return fixed4(col.r, col.g, col.b,col2.r);
			}
			ENDCG 
		}
	}	
}
}

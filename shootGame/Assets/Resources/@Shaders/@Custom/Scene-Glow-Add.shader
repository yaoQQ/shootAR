// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Particles/Scene-Glow-Add"
{
Properties 
{
	_TintColor ("Tint Color", Color) = (1.0,1.0,1.0,1.0)
	_MainTex ("Particle Texture", 2D) = "white" {}
	    _GlowOffsetX ("Glow Offset x", Float) = 0.0
	    _GlowOffsetY ("Glow Offset Y", Float) = 0.0
		_GlowPow ("Glow Pow", float) = 1.0

}

Category 
{
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend One One
	AlphaTest Greater .01
	//ColorMask RGB
	Cull Off Lighting Off ZWrite Off
	
	SubShader 
	{
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _TintColor;
		    float _GlowOffsetX;
            float _GlowOffsetY;
		    float _GlowPow;
			
			struct appdata_t 
			{
				float4 color : COLOR;
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};


			struct v2f 
			{
				float4 color : COLOR;
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
                float moveTimeX = _Time * _GlowOffsetX;
	            float moveTimeY = _Time * _GlowOffsetY;
	            float2 texOffset = fixed2(i.uv.x + moveTimeX, i.uv.y + moveTimeY);

				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col1 = tex2D(_MainTex, texOffset);

				col1 = col1 * col.a
				
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0));
				return col1 * _GlowPow * _TintColor * i.color;
			}
			ENDCG 
		}
	}	
}
}
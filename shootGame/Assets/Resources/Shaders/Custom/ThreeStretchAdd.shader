// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// FActor Studio
// Written by Krolik Chen (krolikchn@gmail.com) 10 March 2016.
Shader "Custom/FActor/ThreeStretch Add"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("_MainTex", 2D) = "white" {}
		_UStretech("U Stretech(XYZ) Offset Scale(W)", Vector) = (1,2,3,0)
		_VStretech("V Stretech", Vector) = (1,2,3,0)
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
		LOD 100

		Pass
		{
			Blend One One
			Zwrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _UStretech;
			float4 _VStretech;
			fixed4 _TintColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed3 vstretch = i.uv.y * _VStretech - (_VStretech-1)*0.5;
				fixed4 col = tex2D(_MainTex, i.uv * float2(_UStretech.x, _VStretech.x) - float2(0,(_VStretech.x-1)*0.5) + _UStretech.w*float2(_MainTex_ST.z, 0)*0.5) * (vstretch.x <1 && vstretch.x >0) +
							tex2D(_MainTex, i.uv* float2(_UStretech.y, _VStretech.y) - float2(0, (_VStretech.y - 1)*0.5)) * (vstretch.y <1 && vstretch.y >0) +
							tex2D(_MainTex, i.uv* float2(_UStretech.z, _VStretech.z) - float2(0, (_VStretech.z - 1)*0.5) - _UStretech.w*float2(_MainTex_ST.z, 0)*0.5) * (vstretch.z <1 && vstretch.z >0);
				col *= i.color*2 * _TintColor.a;
				// apply fog
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0));
				return col;
			}
			ENDCG
		}
	}
}

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/FOWSeeThroughShader" 
{	
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Blur("Blur", float) = 0
	}

	SubShader 
	{
		//Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue"="Transparent" }
		Tags { "RenderType"="Opaque" "Queue"="Geometry+500" }
		Cull Off
		Lighting Off
		Blend DstColor Zero
		//Blend One One
		ZWrite Off
		//ZTest Always
		//Fog {Mode Off}

		Pass
		{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma multi_compile_fwdbase
            //#pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

		    sampler2D _MainTex;
		    fixed4 _MainTex_TexelSize;
		    fixed4 _MainTex_ST;
		    fixed _Blur;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);

				if (_Blur > 0)
                {
                    fixed spread = _Blur*_MainTex_TexelSize*0.75;
                    c += tex2D(_MainTex, i.uv + fixed2(spread, spread));
                    c += tex2D(_MainTex, i.uv + fixed2(-spread, spread));
                    c += tex2D(_MainTex, i.uv + fixed2(-spread, -spread));
                    c += tex2D(_MainTex, i.uv + fixed2(spread, -spread));

                    c += tex2D(_MainTex, i.uv + fixed2(spread, 0));
                    c += tex2D(_MainTex, i.uv + fixed2(-spread, 0));
                    c += tex2D(_MainTex, i.uv + fixed2(0, spread));
                    c += tex2D(_MainTex, i.uv + fixed2(0, -spread));

                    c *= 0.105;
                }

				return c*c*(c*1.2);
				//return -c;
			}

		ENDCG
	    }
	}
	//Fallback "Diffuse"
}
Shader "Hidden/FOWViewStampShader" 
{
	Properties
	{
		_MainTex("Particle Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Blend One One
		Cull Off 
		Lighting Off 
		ZWrite Off 
		Fog{ Mode Off }

		Pass
		{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

	        sampler2D _MainTex;
	        fixed4 _MainTex_TexelSize;
	        fixed4 _MainTex_ST;
	        fixed4 _TintColor;

	        struct appdata_t
	        {
		        //float4 position : POSITION;
		        float4 vertex : POSITION;
		        float4 texcoord : TEXCOORD0;
		        float4 color : COLOR;
	        };

	        struct v2f
	        {
		        //float4 position : SV_POSITION;
		        float4 vertex : SV_POSITION;
		        float2 texcoord : TEXCOORD0;
		        float4 color : COLOR;
	        };

	        v2f vert(appdata_t v)
	        {
		        v2f o;
		        //o.position = mul(UNITY_MATRIX_MVP, v.position);
		        o.vertex = UnityObjectToClipPos(v.vertex);
		        o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
		        o.color = v.color;
		        return o;
	        }

	        fixed4 frag(v2f i) : SV_Target
	        {
		        fixed4 col = 2 * tex2D(_MainTex, i.texcoord);
		        if (col.a < 0.5) discard;
		        //if (col.a < 0.5);
		        return col;
	        }

		ENDCG
		}
    }
	//Fallback "Diffuse"
}
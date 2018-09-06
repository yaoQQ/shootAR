// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Hero/VF-CubeBumpSpe-small" 
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Main Mapping(RGB)", 2D) = "white" {}
		_GlowPow ("Glow Pow", float) = 0.0

		_DisintegrateTex  ("Disintegrate", 2D) = "white" {}
        _EdgeColor("Edge Color", Color) = (1.0,0.5,0.2,0.0)
        _EdgeRange("Edge Range",Range(0.0,0.1)) = 0.002
	    _DisintegrateAmount("Disintegrate Amount", Range(-1.0,1.0)) = 0
	}

	SubShader
	{
        Tags
        {
           "Queue"="Geometry"
           "RenderType"="Opaque"
        }

        Pass
        {
            Tags
            {
               "LightMode"="ForwardBase"
            }

            LOD 200
              
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            fixed4 _Color;
            fixed4 _MainTex_ST;
            sampler2D _MainTex;
            fixed _GlowPow;

		    fixed4 _DisintegrateTex_ST;
		    sampler2D _DisintegrateTex;
            fixed4 _EdgeColor;
            fixed _DisintegrateAmount;
            fixed _EdgeRange;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                                                                
                output.pos = UnityObjectToClipPos(input.vertex);

                output.uv = TRANSFORM_TEX(input.texcoord, _MainTex);
                output.uv2 = TRANSFORM_TEX(input.texcoord1, _DisintegrateTex);

                return output;
            }

            fixed4 frag(vertexOutput input) : COLOR
            {
                fixed4 c = tex2D(_MainTex, input.uv) * _Color;

                fixed4 col = c + c * c * _GlowPow;

                fixed4 mask = tex2D (_DisintegrateTex, input.uv2) * normalize(_DisintegrateAmount);
                fixed clipval = mask.r - _DisintegrateAmount;

                //fixed clipval = (tex2D (_DisintegrateTex, input.uv2).rgb *  normalize(_DisintegrateAmount)) - _DisintegrateAmount;

                clip(clipval);
	
	            if (clipval < _EdgeRange )
	            {
		            col = _EdgeColor;
		            return col;
                }
                else    
                {
		            return col;
	            }
            }
		    ENDCG
		}
	}
	//Fallback "Legacy Shaders/VertexLit"
}
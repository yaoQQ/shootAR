// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/SF_Radial_RtoTex_GtoPanMask_BtoMask" {
    Properties {
        _Color ("Color", Color) = (0.6282426,1,0.3161765,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _RadialUV ("RadialUV", 2D) = "white" {}
        _PanSpeed ("PanSpeed", Float ) = 1
        _MainTex_copy ("MainTex_copy", 2D) = "white" {}
        _GlowStrength ("GlowStrength", Float ) = 2
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {

            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _RadialUV; uniform float4 _RadialUV_ST;
            uniform float _PanSpeed;
            uniform sampler2D _MainTex_copy; uniform float4 _MainTex_copy_ST;
            uniform float _GlowStrength;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 node_9629 = _Time + _TimeEditor;
                float4 _RadialUV_var = tex2D(_RadialUV,TRANSFORM_TEX(i.uv0, _RadialUV));
                float2 node_1492 = (float2(_RadialUV_var.r,_RadialUV_var.g)+(node_9629.g*_PanSpeed)*float2(0.1,-1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_1492, _MainTex));
                float4 _MainTex_copy_var = tex2D(_MainTex_copy,TRANSFORM_TEX(i.uv0, _MainTex_copy));
                float3 emissive = (((_Color.rgb*((_MainTex_var.g*_MainTex_copy_var.r)*_MainTex_copy_var.b))*_GlowStrength)*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,i.vertexColor.a);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
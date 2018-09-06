// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/SF_FlowMapBasic" {
    Properties {
        _Color ("Color", Color) = (0.4308316,0.1029412,1,1)
        _FlowMap ("FlowMap", 2D) = "white" {}
        _U_PanSpeed ("U_PanSpeed", Float ) = 0.1
        _V_PanSpeed ("V_PanSpeed", Float ) = 1
        _FlowStrength ("FlowStrength", Float ) = 0.25
        _UseR_GforAlpha ("UseR_GforAlpha", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 2
        _AlphaStrength ("AlphaStrength", Float ) = 1
        _FlowMap_copy ("FlowMap_copy", 2D) = "white" {}
        _DarkGlowStrength ("DarkGlowStrength", Range(0, 1)) = 1
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
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZTest Always
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _U_PanSpeed;
            uniform float _V_PanSpeed;
            uniform float _FlowStrength;
            uniform sampler2D _UseR_GforAlpha; uniform float4 _UseR_GforAlpha_ST;
            uniform float _EmissStrength;
            uniform float _AlphaStrength;
            uniform sampler2D _FlowMap_copy; uniform float4 _FlowMap_copy_ST;
            uniform float _DarkGlowStrength;
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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_3332 = _Time + _TimeEditor;
                float2 node_1225 = (i.uv0+(node_3332.g*_U_PanSpeed)*float2(1,0));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_1225, _FlowMap));
                float node_8812 = (_FlowStrength+1.0);
                float2 node_776 = (i.uv0+(node_3332.g*_V_PanSpeed)*float2(0,1));
                float4 _FlowMap_copy_var = tex2D(_FlowMap_copy,TRANSFORM_TEX(node_776, _FlowMap_copy));
                float2 node_3234 = float2(clamp((((_FlowMap_var.r*_FlowStrength)+i.uv0.r)/node_8812),0,1),clamp((((_FlowMap_copy_var.g*_FlowStrength)+i.uv0.g)/node_8812),0,1));
                float4 _UseR_GforAlpha_var = tex2D(_UseR_GforAlpha,TRANSFORM_TEX(node_3234, _UseR_GforAlpha));
                float3 emissive = ((((((_Color.rgb*_UseR_GforAlpha_var.r)+(_UseR_GforAlpha_var.rgb*_UseR_GforAlpha_var.rgb))+(_DarkGlowStrength*_Color.rgb))/2.0)*i.vertexColor.rgb)*_EmissStrength);
                float3 finalColor = emissive;
                return fixed4(finalColor,((i.vertexColor.a*_UseR_GforAlpha_var.g)*_AlphaStrength));
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
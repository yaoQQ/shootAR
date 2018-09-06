// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/SF_Lightning" {
    Properties {
        _Color ("Color", Color) = (0.2352941,0.4915308,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 2
        _FlowMap ("FlowMap", 2D) = "white" {}
        _V_FlowPanSpeed ("V_FlowPanSpeed", Float ) = 2
        _U_FlowPanSpeed ("U_FlowPanSpeed", Float ) = 4
        _FlowMap_copy ("FlowMap_copy", 2D) = "white" {}
        _FlowMap_U ("FlowMap_U", 2D) = "white" {}
        _FlowStrength ("FlowStrength", Float ) = 0.1
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
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _EmissStrength;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _V_FlowPanSpeed;
            uniform float _U_FlowPanSpeed;
            uniform sampler2D _FlowMap_copy; uniform float4 _FlowMap_copy_ST;
            uniform sampler2D _FlowMap_U; uniform float4 _FlowMap_U_ST;
            uniform float _FlowStrength;
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
                float4 node_3020 = _Time + _TimeEditor;
                float2 node_1058 = (i.uv0+(node_3020.g*_U_FlowPanSpeed)*float2(1,0));
                float4 _FlowMap_U_var = tex2D(_FlowMap_U,TRANSFORM_TEX(node_1058, _FlowMap_U));
                float2 node_87 = (i.uv0+(node_3020.g*_V_FlowPanSpeed)*float2(0,1));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_87, _FlowMap));
                float2 node_585 = (i.uv0+((_V_FlowPanSpeed*0.25)*node_3020.g)*float2(0.1,1));
                float4 _FlowMap_copy_var = tex2D(_FlowMap_copy,TRANSFORM_TEX(node_585, _FlowMap_copy));
                float2 node_4546 = (i.uv0+(float2(_FlowMap_U_var.r,((_FlowMap_var.g+_FlowMap_copy_var.g)/2.0))*_FlowStrength));
                float node_5900 = (_FlowStrength+1.0);
                float2 node_4171 = float2((node_4546.r/node_5900),(node_4546.g/node_5900));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_4171, _MainTex));
                float3 emissive = (((_Color.rgb*(_MainTex_var.r/0.5))*i.vertexColor.rgb)*_EmissStrength);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
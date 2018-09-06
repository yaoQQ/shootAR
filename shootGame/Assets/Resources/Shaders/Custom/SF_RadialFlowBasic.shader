// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/SF_RadialFlowBasic" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _V_OffsetSpeed ("V_OffsetSpeed", Float ) = 0.1
        _U_OffsetSpeed ("U_OffsetSpeed", Float ) = 0
        _RadialUV_BtoMask ("RadialUV_BtoMask", 2D) = "white" {}
        _FlowStrength ("FlowStrength", Float ) = 0.2
        _Color ("Color", Color) = (1,1,1,1)
        _EmissStrength ("EmissStrength", Float ) = 1
        _Mask ("Mask", 2D) = "white" {}
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _V_OffsetSpeed;
            uniform float _U_OffsetSpeed;
            uniform sampler2D _RadialUV_BtoMask; uniform float4 _RadialUV_BtoMask_ST;
            uniform float _FlowStrength;
            uniform float4 _Color;
            uniform float _EmissStrength;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
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
                float4 node_3416 = _Time + _TimeEditor;
                float4 _RadialUV_BtoMask_var = tex2D(_RadialUV_BtoMask,TRANSFORM_TEX(i.uv0, _RadialUV_BtoMask));
                float2 node_9865 = float2(_RadialUV_BtoMask_var.r,_RadialUV_BtoMask_var.g);
                float2 node_3562 = float2((node_9865+(node_3416.g*_U_OffsetSpeed)*float2(1,0)).r,(node_9865+(node_3416.g*_V_OffsetSpeed)*float2(0,1)).g);
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_3562, _FlowMap));
                float2 node_8494 = (i.uv0+(_FlowMap_var.rgb.rg*_FlowStrength));
                float node_2878 = (_FlowStrength+1.0);
                float2 node_4402 = float2((node_8494.r/node_2878),(node_8494.g/node_2878));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_4402, _MainTex));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 emissive = ((((_Color.rgb*(((_MainTex_var.r*_MainTex_var.r)+_MainTex_var.r)*_RadialUV_BtoMask_var.b))*_EmissStrength)*i.vertexColor.rgb)*_Mask_var.r);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/S_VertexOffset" {
    Properties {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _OffsetMap ("OffsetMap", 2D) = "white" {}
        _Offset_Strength ("Offset_Strength", Float ) = 0.1
        _OffsetMap_copy ("OffsetMap_copy", 2D) = "white" {}
        _Offset_Speed ("Offset_Speed", Float ) = 1
        _OffsetMap_copy_copy ("OffsetMap_copy_copy", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 2
        _Grid ("Grid", 2D) = "white" {}
        _DiffuseStrength ("DiffuseStrength", Float ) = 1
        _InnerValue ("InnerValue", Float ) = 0
        _DX11_Tessellation ("DX11_Tessellation", Float ) = 8
        _Fresnel_EXP ("Fresnel_EXP", Float ) = 1
        _FresnalEdge ("FresnalEdge", Float ) = 2
        _FresnelStrength ("FresnelStrength", Float ) = 0.5
        _node_5847 ("node_5847", 2D) = "white" {}
        _DiffFlowStrength ("DiffFlowStrength", Float ) = 0.035
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
            uniform sampler2D _OffsetMap; uniform float4 _OffsetMap_ST;
            uniform float _Offset_Strength;
            uniform sampler2D _OffsetMap_copy; uniform float4 _OffsetMap_copy_ST;
            uniform float _Offset_Speed;
            uniform sampler2D _OffsetMap_copy_copy; uniform float4 _OffsetMap_copy_copy_ST;
            uniform float _EmissStrength;
            uniform sampler2D _Grid; uniform float4 _Grid_ST;
            uniform float _InnerValue;
            uniform float _DiffuseStrength;
            uniform float _Fresnel_EXP;
            uniform float _FresnelStrength;
            uniform sampler2D _node_5847; uniform float4 _node_5847_ST;
            uniform float _DiffFlowStrength;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_9138 = _Time + _TimeEditor;
                float node_4632 = (node_9138.g*_Offset_Speed);
                float2 node_4356 = (o.uv0+node_4632*float2(0.1,0));
                float4 _OffsetMap_var = tex2Dlod(_OffsetMap,float4(TRANSFORM_TEX(node_4356, _OffsetMap),0.0,0));
                float2 node_5920 = (o.uv0+node_4632*float2(0,-0.1));
                float4 _OffsetMap_copy_var = tex2Dlod(_OffsetMap_copy,float4(TRANSFORM_TEX(node_5920, _OffsetMap_copy),0.0,0));
                float4 node_4663 = _Time + _TimeEditor;
                float node_5165_ang = node_4663.g;
                float node_5165_spd = (-0.2);
                float node_5165_cos = cos(node_5165_spd*node_5165_ang);
                float node_5165_sin = sin(node_5165_spd*node_5165_ang);
                float2 node_5165_piv = float2(0.5,0.5);
                float2 node_5165 = (mul(o.uv0-node_5165_piv,float2x2( node_5165_cos, -node_5165_sin, node_5165_sin, node_5165_cos))+node_5165_piv);
                float4 _OffsetMap_copy_copy_var = tex2Dlod(_OffsetMap_copy_copy,float4(TRANSFORM_TEX(node_5165, _OffsetMap_copy_copy),0.0,0));
                float node_5589 = ((_OffsetMap_var.r*_OffsetMap_copy_var.g)+_OffsetMap_copy_copy_var.b);
                v.vertex.xyz += ((v.normal*node_5589)*_Offset_Strength);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_9138 = _Time + _TimeEditor;
                float node_4632 = (node_9138.g*_Offset_Speed);
                float2 node_3971 = ((i.uv0*1.0)+node_4632*float2(0.1,-0.1));
                float4 _node_5847_var = tex2D(_node_5847,TRANSFORM_TEX(node_3971, _node_5847));
                float2 node_8126 = (i.uv0+(_node_5847_var.r*_DiffFlowStrength));
                float4 _Grid_var = tex2D(_Grid,TRANSFORM_TEX(node_8126, _Grid));
                float2 node_4356 = (i.uv0+node_4632*float2(0.1,0));
                float4 _OffsetMap_var = tex2D(_OffsetMap,TRANSFORM_TEX(node_4356, _OffsetMap));
                float2 node_5920 = (i.uv0+node_4632*float2(0,-0.1));
                float4 _OffsetMap_copy_var = tex2D(_OffsetMap_copy,TRANSFORM_TEX(node_5920, _OffsetMap_copy));
                float4 node_4663 = _Time + _TimeEditor;
                float node_5165_ang = node_4663.g;
                float node_5165_spd = (-0.2);
                float node_5165_cos = cos(node_5165_spd*node_5165_ang);
                float node_5165_sin = sin(node_5165_spd*node_5165_ang);
                float2 node_5165_piv = float2(0.5,0.5);
                float2 node_5165 = (mul(i.uv0-node_5165_piv,float2x2( node_5165_cos, -node_5165_sin, node_5165_sin, node_5165_cos))+node_5165_piv);
                float4 _OffsetMap_copy_copy_var = tex2D(_OffsetMap_copy_copy,TRANSFORM_TEX(node_5165, _OffsetMap_copy_copy));
                float node_5589 = ((_OffsetMap_var.r*_OffsetMap_copy_var.g)+_OffsetMap_copy_copy_var.b);
                float node_8661 = ((pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fresnel_EXP)+_InnerValue)*_FresnelStrength);
                float3 emissive = ((_Color.rgb*(((8.0*((_Grid_var.b*_DiffuseStrength)*(pow(node_5589,3.0)*4.0)))+node_8661)*_EmissStrength))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Shader Forge/SF_StarFlowRim" {
    Properties {
        _Color ("Color", Color) = (1,0.4394191,0.05147058,1)
        _Noise ("Noise", 2D) = "white" {}
        _Noise_copy ("Noise_copy", 2D) = "white" {}
        _Noise_copy_copy ("Noise_copy_copy", 2D) = "white" {}
        _RotateSpeed ("RotateSpeed", Float ) = 0.1
        _U_PanSpeed ("U_PanSpeed", Float ) = 0.5
        _V_PanSpeed ("V_PanSpeed", Float ) = 0.5
        _FresnelExp ("FresnelExp", Float ) = 1
        _EmissStrength ("EmissStrength", Float ) = 1
        _FlowMap ("FlowMap", 2D) = "white" {}
        _FlowMap_copy ("FlowMap_copy", 2D) = "white" {}
        _FlowStrength ("FlowStrength", Float ) = 0.25
        _FlowSpeed ("FlowSpeed", Float ) = 0.1
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {

            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _Noise; uniform float4 _Noise_ST;
            uniform sampler2D _Noise_copy; uniform float4 _Noise_copy_ST;
            uniform sampler2D _Noise_copy_copy; uniform float4 _Noise_copy_copy_ST;
            uniform float _RotateSpeed;
            uniform float _U_PanSpeed;
            uniform float _V_PanSpeed;
            uniform float _FresnelExp;
            uniform float _EmissStrength;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform sampler2D _FlowMap_copy; uniform float4 _FlowMap_copy_ST;
            uniform float _FlowStrength;
            uniform float _FlowSpeed;
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
                //o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.normalDir =  normalize(mul(fixed4(v.normal, 0.0), unity_WorldToObject).xyz);
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
                float4 node_129 = _Time + _TimeEditor;
                float2 node_2039 = (i.uv0+(node_129.r*_U_PanSpeed)*float2(1,0));
                float4 _Noise_var = tex2D(_Noise,TRANSFORM_TEX(node_2039, _Noise));
                float2 node_3359 = (i.uv0+(node_129.r*_V_PanSpeed)*float2(0,1));
                float4 _Noise_copy_var = tex2D(_Noise_copy,TRANSFORM_TEX(node_3359, _Noise_copy));
                float node_642 = (_Noise_var.r*_Noise_copy_var.g);
                float4 node_4482 = _Time + _TimeEditor;
                float node_5332_ang = node_4482.g;
                float node_5332_spd = _RotateSpeed;
                float node_5332_cos = cos(node_5332_spd*node_5332_ang);
                float node_5332_sin = sin(node_5332_spd*node_5332_ang);
                float2 node_5332_piv = float2(0.5,0.5);
                float node_5285 = (node_129.r*_FlowSpeed);
                float2 node_5315 = (i.uv0+node_5285*float2(1,0));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_5315, _FlowMap));
                float2 node_4530 = (i.uv0+node_5285*float2(0,1));
                float4 _FlowMap_copy_var = tex2D(_FlowMap_copy,TRANSFORM_TEX(node_4530, _FlowMap_copy));
                float2 node_5332 = (mul((i.uv0+(float2(_FlowMap_var.r,_FlowMap_copy_var.g)*_FlowStrength))-node_5332_piv,float2x2( node_5332_cos, -node_5332_sin, node_5332_sin, node_5332_cos))+node_5332_piv);
                float4 _Noise_copy_copy_var = tex2D(_Noise_copy_copy,TRANSFORM_TEX(node_5332, _Noise_copy_copy));
                float node_6465 = (node_642+_Noise_copy_copy_var.b);
                float node_5876 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_FresnelExp);
                float3 emissive = ((((_Color.rgb*((node_642+node_6465)+(node_6465*_Noise_copy_copy_var.b)))+((node_5876*0.25)+((node_5876*node_5876)*0.25)))*_EmissStrength)*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return float4(finalColor,1);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
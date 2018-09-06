// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Shader Forge/SF_FlowPanner" {
    Properties {
        _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex ("MainTex", 2D) = "white" {}
        _Indensity ("Main Map Indensity", Float) = 1.0
        _FlowMap ("FlowMap", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _Emissive_Strength ("Emissive_Strength", Float ) = 1
        _Alpha_Strength ("Alpha_Strength", Float ) = 2
        _FlowMap_Strength ("FlowMap_Strength", Float ) = 0.1
        _FlowU_Offset ("FlowU_Offset", Float ) = 1
        _MainTex_Voffset ("MainTex_Voffset", Float ) = 0.5
        _FlowMap_copy ("FlowMap_copy", 2D) = "white" {}
        _FlowV_Offset ("FlowV_Offset", Float ) = 1
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
            //Blend SrcAlpha OneMinusSrcAlpha
            Blend SrcAlpha One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Emissive_Strength;
            uniform float _Alpha_Strength;
            uniform float _FlowMap_Strength;
            uniform float _FlowU_Offset;
            uniform float _MainTex_Voffset;
            uniform sampler2D _FlowMap_copy; uniform float4 _FlowMap_copy_ST;
            uniform float _FlowV_Offset;
            float4 _TintColor;
            float _Indensity;

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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_8540 = _Time + _TimeEditor;
                float4 node_7117 = _Time + _TimeEditor;
                float2 node_5124 = (i.uv0+(node_7117.g*_FlowU_Offset)*float2(1,0));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_5124, _FlowMap));
                float2 node_1432 = (i.uv0+(node_7117.g*_FlowV_Offset)*float2(0,1));
                float4 _FlowMap_copy_var = tex2D(_FlowMap_copy,TRANSFORM_TEX(node_1432, _FlowMap_copy));
                float2 node_8492 = ((i.uv0+(float2(_FlowMap_var.r,_FlowMap_copy_var.g)*_FlowMap_Strength))+(node_8540.g*_MainTex_Voffset)*float2(0,1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_8492, _MainTex));
                float3 emissive = ((_MainTex_var.rgb*i.vertexColor.rgb)*_Emissive_Strength);
                float3 finalColor = emissive;
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float node_1148 = (1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),3.0));
                return float4(finalColor,(((i.vertexColor.a*(_MainTex_var.r*_Mask_var.r))*_Alpha_Strength)*(node_1148*node_1148))) * _TintColor * _Indensity;
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
    //CustomEditor "ShaderForgeMaterialInspector"
}
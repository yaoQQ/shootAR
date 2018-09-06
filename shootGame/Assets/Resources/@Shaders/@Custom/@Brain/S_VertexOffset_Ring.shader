// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Forge/S_VertexOffset_Ring" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _FlowSpeed ("FlowSpeed", Float ) = 0.1
        _FlowStrength ("FlowStrength", Float ) = 0.5
        _NoiseWave ("NoiseWave", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 2
        _NoiseTexPanner ("NoiseTexPanner", Float ) = 1
        _VertexOffset_Srt ("VertexOffset_Srt", Float ) = 0.25
        _ShineFrequency ("ShineFrequency", Float ) = 4
        _FlowMap_copy ("FlowMap_copy", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }

    SubShader 
    {
        Tags 
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Pass 
        {

            Tags 
            {
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
            #pragma multi_compile_fwdbase_fullshadows
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 3.0
            //#pragma glsl

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _FlowSpeed;
            uniform float _FlowStrength;
            uniform sampler2D _NoiseWave; uniform float4 _NoiseWave_ST;
            uniform float _EmissStrength;
            uniform float _NoiseTexPanner;
            uniform float _VertexOffset_Srt;
            uniform float _ShineFrequency;
            uniform sampler2D _FlowMap_copy; uniform float4 _FlowMap_copy_ST;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 _MainTex_var = tex2Dlod(_MainTex,float4(TRANSFORM_TEX(o.uv0, _MainTex),0.0,0));
                v.vertex.xyz += (((_MainTex_var.g+0.5)*(v.normal*float3(1,0,1)))*_VertexOffset_Srt);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }

            float4 frag(VertexOutput i, float facing : VFACE) : COLOR 
            {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_3154 = _Time + _TimeEditor;
                float node_749 = (node_3154.g*_FlowSpeed);
                float2 node_6588 = (i.uv0+node_749*float2(1,0));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_6588, _FlowMap));
                float2 node_3602 = (i.uv0+node_749*float2(0,1));
                float4 _FlowMap_copy_var = tex2D(_FlowMap_copy,TRANSFORM_TEX(node_3602, _FlowMap_copy));
                float2 node_1180 = ((i.uv0+((_FlowMap_var.r*_FlowMap_copy_var.g)*_FlowStrength))+(node_3154.g*_NoiseTexPanner)*float2(1,0));
                float4 _NoiseWave_var = tex2D(_NoiseWave,TRANSFORM_TEX(node_1180, _NoiseWave));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = ((((_Color.rgb*(((pow(_NoiseWave_var.r,3.0)*4.0)*_MainTex_var.g)+_MainTex_var.g))*_EmissStrength)*((((sin((node_3154.g*_ShineFrequency))*0.3)+2.0)/2.0)*2.0))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,((i.vertexColor.a*_MainTex_var.g)*((pow(1.0-max(0,dot(normalDirection, viewDirection)),1.0)*2.0)+0.4)));
            }
            ENDCG
        }

    }
    //FallBack "Diffuse"
}
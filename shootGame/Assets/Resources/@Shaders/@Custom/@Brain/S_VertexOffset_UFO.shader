// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Forge/S_VertexOffset_UFO" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 2
        _ShinnyFrequency ("ShinnyFrequency", Float ) = 16
        _VertexOffset_Srt ("VertexOffset_Srt", Float ) = 0.1
        _Tessellation_Amount ("Tessellation_Amount", Float ) = 2
        [MaterialToggle] _SwithRorBchannel ("SwithRorBchannel", Float ) = 0
    }

    SubShader 
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Pass 
        {

            Tags 
            {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZTest Always
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 3.0
            //#pragma glsl

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _EmissStrength;
            uniform float _ShinnyFrequency;
            uniform float _VertexOffset_Srt;
            uniform fixed _SwithRorBchannel;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 _MainTex_var = tex2Dlod(_MainTex,float4(TRANSFORM_TEX(o.uv0, _MainTex),0.0,0));
                float _SwithRorBchannel_var = lerp( _MainTex_var.r, _MainTex_var.b, _SwithRorBchannel );
                v.vertex.xyz += ((_SwithRorBchannel_var*v.normal)*_VertexOffset_Srt);
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
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float _SwithRorBchannel_var = lerp( _MainTex_var.r, _MainTex_var.b, _SwithRorBchannel );
                float4 node_9057 = _Time + _TimeEditor;
                float3 emissive = ((_Color.rgb*(_SwithRorBchannel_var+(_MainTex_var.r*((((sin((node_9057.g*_ShinnyFrequency))*0.2)+1.0)/2.0)*2.0))))*_EmissStrength);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }

    }
    //FallBack "Diffuse"
}
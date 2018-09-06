// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3138,x:34000,y:32802,varname:node_3138,prsc:2|emission-9693-OUT,custl-4514-RGB,clip-274-OUT;n:type:ShaderForge.SFN_Tex2d,id:4514,x:32848,y:32715,ptovrint:False,ptlb:node_4514,ptin:_node_4514,varname:node_4514,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2090,x:32458,y:32825,ptovrint:False,ptlb:node_2090,ptin:_node_2090,varname:node_2090,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3394,x:32793,y:32969,varname:node_3394,prsc:2|A-2090-RGB,B-8503-OUT;n:type:ShaderForge.SFN_Slider,id:8503,x:32502,y:33198,ptovrint:False,ptlb:blendAmount,ptin:_blendAmount,varname:node_8503,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5656233,max:1;n:type:ShaderForge.SFN_Multiply,id:2717,x:32974,y:32982,varname:node_2717,prsc:2|A-3394-OUT,B-3239-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3239,x:32821,y:33136,ptovrint:False,ptlb:node_3239,ptin:_node_3239,varname:node_3239,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:9;n:type:ShaderForge.SFN_TexCoord,id:63,x:32321,y:33029,varname:node_63,prsc:2,uv:0;n:type:ShaderForge.SFN_ConstantClamp,id:274,x:33524,y:33035,varname:node_274,prsc:2,min:0,max:1|IN-5297-OUT;n:type:ShaderForge.SFN_Power,id:5297,x:33205,y:33039,varname:node_5297,prsc:2|VAL-2717-OUT,EXP-3523-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3523,x:32974,y:33176,ptovrint:False,ptlb:node_3523,ptin:_node_3523,varname:node_3523,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:100;n:type:ShaderForge.SFN_If,id:5852,x:33479,y:33322,varname:node_5852,prsc:2|A-6683-OUT,B-5297-OUT,GT-5933-OUT,EQ-6908-OUT,LT-6908-OUT;n:type:ShaderForge.SFN_Slider,id:6683,x:33048,y:33250,ptovrint:False,ptlb:node_6683,ptin:_node_6683,varname:node_6683,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1000,max:1000;n:type:ShaderForge.SFN_ValueProperty,id:5933,x:33085,y:33338,ptovrint:False,ptlb:node_5933,ptin:_node_5933,varname:node_5933,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:6908,x:33071,y:33423,ptovrint:False,ptlb:node_6908,ptin:_node_6908,varname:node_6908,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:9693,x:33677,y:33309,varname:node_9693,prsc:2|A-5852-OUT,B-2193-RGB;n:type:ShaderForge.SFN_Color,id:2193,x:33462,y:33490,ptovrint:False,ptlb:sideColor,ptin:_sideColor,varname:node_2193,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0,c3:0,c4:1;proporder:4514-8503-3239-2090-3523-6683-5933-6908-2193;pass:END;sub:END;*/

Shader "Shader Forge/showDisapear" {
    Properties {
        _node_4514 ("node_4514", 2D) = "white" {}
        _blendAmount ("blendAmount", Range(0, 1)) = 0.5656233
        _node_3239 ("node_3239", Float ) = 9
        _node_2090 ("node_2090", 2D) = "white" {}
        _node_3523 ("node_3523", Float ) = 100
        _node_6683 ("node_6683", Range(0, 1000)) = 1000
        _node_5933 ("node_5933", Float ) = 1
        _node_6908 ("node_6908", Float ) = 0
        _sideColor ("sideColor", Color) = (1,0,0,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _node_4514; uniform float4 _node_4514_ST;
            uniform sampler2D _node_2090; uniform float4 _node_2090_ST;
            uniform float _blendAmount;
            uniform float _node_3239;
            uniform float _node_3523;
            uniform float _node_6683;
            uniform float _node_5933;
            uniform float _node_6908;
            uniform float4 _sideColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _node_2090_var = tex2D(_node_2090,TRANSFORM_TEX(i.uv0, _node_2090));
                float3 node_5297 = pow(((_node_2090_var.rgb*_blendAmount)*_node_3239),_node_3523);
                clip(clamp(node_5297,0,1) - 0.5);
////// Lighting:
////// Emissive:
                float node_5852_if_leA = step(_node_6683,node_5297);
                float node_5852_if_leB = step(node_5297,_node_6683);
                float3 emissive = (lerp((node_5852_if_leA*_node_6908)+(node_5852_if_leB*_node_5933),_node_6908,node_5852_if_leA*node_5852_if_leB)*_sideColor.rgb);
                float4 _node_4514_var = tex2D(_node_4514,TRANSFORM_TEX(i.uv0, _node_4514));
                float3 finalColor = emissive + _node_4514_var.rgb;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _node_2090; uniform float4 _node_2090_ST;
            uniform float _blendAmount;
            uniform float _node_3239;
            uniform float _node_3523;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _node_2090_var = tex2D(_node_2090,TRANSFORM_TEX(i.uv0, _node_2090));
                float3 node_5297 = pow(((_node_2090_var.rgb*_blendAmount)*_node_3239),_node_3523);
                clip(clamp(node_5297,0,1) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

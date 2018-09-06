using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 战损控制器
/// </summary>
public class DecalController : MonoBehaviour
{

    private MeshRenderer[] m_renderers;
    private float m_tmpValue;
    public static readonly string DisintegrateAmountParameter = "_DisintegrateAmount";
    public static readonly string EdgeRangeRenderParameter = "_EdgeRange";

    public float percentTest = 0.5f;
    void Awake()
    {
        this.m_renderers = GetComponentsInChildren<MeshRenderer>();
    }

    public float time = 0;
    public bool isShow = false;
    public float percent;
    public void Update()
    {
        if (!isShow)
        {
            return;
        }
        time += Time.deltaTime;
        percent = time / 50;
        LeapIning(percent);
        if (time >= 2)
        {
            BeginLeapOut();
            this.enabled = false;
        }
    }

    //public void OnGUI()
    //{
    //    if (GUI.Button(new Rect(0, 100, 100, 100), "test"))
    //    {
    //        BeginLeapIn();
    //    }

    //    if (GUI.Button(new Rect(0, 150, 100, 100), "test2"))
    //    {
    //    }
    //}

    public void BeginLeapIn()
    {
        this.enabled = true;
        this.m_renderers.cForEach(rd =>
        {
            rd.material.SetFloat(DisintegrateAmountParameter, -0.01f);
            rd.material.SetFloat(EdgeRangeRenderParameter, 0.01f);
        });
        isShow = true;
        time = 0;
    }

    public void LeapIning(float percent)
    {

        this.m_renderers.cForEach(rd =>
        {
            this.m_tmpValue = rd.material.GetFloat(DisintegrateAmountParameter);
            this.m_tmpValue = Mathf.Clamp(this.m_tmpValue - percent, -1, 1);
            rd.material.SetFloat(DisintegrateAmountParameter, this.m_tmpValue);
        });

    }

    public void EndLeapIn()
    {

        this.m_renderers.cForEach(rd =>
        {
            rd.material.SetFloat(DisintegrateAmountParameter, 0.001f);
            rd.material.SetFloat(EdgeRangeRenderParameter, 0);
        });

    }

    public void BeginLeapOut()
    {

        this.m_renderers.cForEach(rd =>
        {
            rd.material.SetFloat(DisintegrateAmountParameter, 0.01f);
            rd.material.SetFloat(EdgeRangeRenderParameter, 0.01f);
        });
    }

    public void LeapOuting(float percent)
    {

        this.m_renderers.cForEach(rd =>
        {
            this.m_tmpValue = rd.material.GetFloat(DisintegrateAmountParameter);
            this.m_tmpValue = Mathf.Clamp(percent + this.m_tmpValue, -1, 1);
            rd.material.SetFloat(DisintegrateAmountParameter, this.m_tmpValue);
        });

    }

    public void EndLeapOut()
    {

        this.m_renderers.cForEach(rd =>
        {
            rd.material.SetFloat(DisintegrateAmountParameter, 1);
            rd.material.SetFloat(EdgeRangeRenderParameter, 0);
        });

    }

    public void Sneak()
    {
        this.gameObject.SetActive(false);
    }
}
public static class CollectionExtensions
{

    public static void cForEach<T>(this List<T> array, Action<T> action)
    {
        if (array == null || array.Count == 0 || action == null) return;
        int length = array.Count;
        for (int i = 0; i < length; i++)
        {
            action(array[i]);
        }
    }

    public static void cForEach<T>(this List<T> array, Action<T, int> action)
    {
        if (array == null || array.Count == 0 || action == null) return;
        int length = array.Count;
        for (int i = 0; i < length; i++)
        {
            action(array[i], i);
        }
    }


    public static void cForEach<T>(this T[] array, Action<T> action)
    {
        if (array == null || array.Length == 0 || action == null) return;
        int length = array.Length;
        for (int i = 0; i < length; i++)
        {
            action(array[i]);
        }
    }

    public static void cForEach<T>(this T[] array, Action<T, int> action)
    {
        if (array == null || array.Length == 0 || action == null) return;
        int length = array.Length;
        for (int i = 0; i < length; i++)
        {
            action(array[i], i);
        }
    }

    public static bool cHandle<T>(this T[] array, Func<T, bool> handler)
    {
        if (array == null || array.Length == 0 || handler == null) return false;
        int length = array.Length;
        for (int i = 0; i < length; i++)
        {
            if (handler(array[i])) return true;
        }
        return false;
    }
}
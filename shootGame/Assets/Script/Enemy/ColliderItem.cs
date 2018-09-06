using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//可碰撞摧毁物体
public class ColliderItem : ResourcePoolEnable
{
    public string _shootTag;//打击的对象
    public virtual void OnTriggerEnter(Collider other)
    {
    
    }

    /// <summary>
    /// 受到伤害
    /// </summary>
    /// <param name="num">伤害值</param>
    /// <param name="target">打击对象</param>
    public virtual void Damage(float num, GameObject target = null)
    {
   
    }
    //射击的对象tag
    public string shootTag
    {
        set
        {
            _shootTag = value;
        }
        get
        {
            return _shootTag;
        }
    }
}


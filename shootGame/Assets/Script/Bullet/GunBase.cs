using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public enum campEnum
{
    Player,
    Enemy
}
public class GunBase : MonoBehaviour, IGunBase
{
    public string bulletName;//子弹对象名

    public float coolTime = 0.3f;//子弹间隔时间

    protected float time = 0;
    public bool isCanShoot = true;

    public campEnum camp = campEnum.Player;
    public virtual void Awake()
    {
        if (this.gameObject.tag.Equals(Tags.Enemy))
        {
            camp = campEnum.Enemy;
        }
        else
        {
            camp = campEnum.Player;
        }
    }

    public virtual void Start()
    {
        
    }


    public virtual void Update()
    {

    }

    //射击
    public virtual void Shoot()
    {

    }


    public virtual void OnDestroy()
    {
        //GunManager.Instance.removeGunBtnEvnt(this);
    }
    public virtual void Dead()
    {
 
    }
}
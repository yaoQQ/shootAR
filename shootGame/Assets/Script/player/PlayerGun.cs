using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class PlayerGun : GunBase, IPlayerGun
{
    //设置玩家射击按钮，标志位
    public PlayerGunBtnsEnum GunBtnPos = PlayerGunBtnsEnum.none;

    //枪的类型
    public GunType gunType = GunType.None;

    protected int bulletCount;//子弹计数
    public int BulletTotolCount;//总子弹数

    private float BulletCollTimeCount;//重置子弹冷却计数
    public float BulletCollTimeTotal;//总子弹冷却时间

    //更新按钮回调
    public delegate void updateGunBtn();
    public updateGunBtn updateBtn;

    public static TargetLog targetLog;  //瞄准器
     
    public override void Start()
    {
        if (PlayerGun.targetLog == null)
            PlayerGun.targetLog = GameObject.Find("targetLog").GetComponent<TargetLog>();
        bulletCount = BulletTotolCount;
        BulletCollTimeCount = 0;
        updateFun();
      
       
    }

    public override void Update()
    {
        if (BulletCollTimeCount > 0)
        {
            BulletCollTimeCount -= Time.deltaTime;
           
            if (BulletCollTimeCount <= 0)
            {
                resetShoot();
            }
            updateFun();
        }
    }
    public PlayerGunBtnsEnum GetGunBtnPos
    {
        get
        {
            return GunBtnPos;
        }
    }
    public int getCurrBulletCount
    {
        get
        {
            return bulletCount;
        }
    }
    public float getBulletCollTimeCount
    {
        get
        {
            return BulletCollTimeCount;
        }
    }
    //是否冷却完毕
    public bool isCool
    {
        get
        {
            return BulletCollTimeCount>0?false:true;
        }
    }

    public override void Shoot()
    {
        if (camp == campEnum.Player)
        {
            PlayerGun.targetLog.shoot();
        }
        updateBullet();
    }

    //更新子弹和刷新时间
    protected virtual void updateBullet()
    {
        if (isCanShoot)
        {
            bulletCount--;
            if (bulletCount <= 0)
            {
                BulletCollTimeCount = BulletCollTimeTotal;
             
            }
            updateFun();
        }
    }


    //刷新重置
    private void resetShoot()
    {
        BulletCollTimeCount = 0;
        bulletCount = BulletTotolCount;
    }
    protected void updateFun()
    {
        if (updateBtn != null)
        {
   
            updateBtn();

        }
    }
    public virtual void BtnPressFun()
    {
        bulletCount--;
    }
    public virtual void BtnUptFun()
    {

    }
    public override void Dead()
    {

    }
}


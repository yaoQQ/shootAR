using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class Shiplight : Enemy
{

    public float shootTime = 3;
    public float attachDistance = 2;//攻击距离
    public LightGun gun;
    public override void Awake()
    {
        base.Awake();
        shipType = EnemyShipType.FarAttack;
        gun = this.gameObject.GetComponentInChildren<LightGun>();
    }
    public override void Active()
    {
        base.Active();
    }
    protected override void behaviour()
    {
        base.behaviour();
    }
    protected override void MoveToPos(Vector3 pos)
    {
        //与玩家保持距离攻击
        if (Vector3.Distance(this.transform.position, CameraManager.Instance.Player.position) <= attachDistance)
        {
            attackPlayer();
            return;
        }
        base.MoveToPos(pos);
        LookAtPos(pos);
    }
    //到达目标点 追逐玩家
    protected override void ArrivePos(Vector3 pos)
    {
        base.ArrivePos(pos);
    }


    //攻击玩家 条件和行为
    protected override void attackPlayer()
    {
        base.attackPlayer();
        if (shipType == EnemyShipType.FarAttack)
        {

            if (gun != null)
            {
                targetPos = CameraManager.Instance.Player.position;
                transform.LookAt(targetPos);
                //   gun.transform.LookAt(targetPos);
                shootTime -= Time.deltaTime;
                if (shootTime<=0)
                {
                    gun.BtnPressFun();
                    shootTime = 3;
                }
            
            }
        }


    }
    public override void Dead()
    {
        base.Dead();
        if (gun != null)
        {
            gun.Dead();
        }
    }
    public void OnDestroy()
    {
        if (gun != null)
        {
            gun.OnDestroy();
            GameObject.Destroy(gun.gameObject);
        }
    }


}


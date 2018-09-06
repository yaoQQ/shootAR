
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ShipMoveOver : Enemy
{

    public LightGun gun;
    public float shootTime = 3;
    public float attachDistance = 2;//攻击距离
    public override void Awake()
    {
        base.Awake();
        shipType = EnemyShipType.FarAttack;
        gun = this.gameObject.GetComponentInChildren<LightGun>();

    }

    public override void Start()
    {
        base.Start();

    }
    public override void Active()
    {
        base.Active();
        shootTime = 3;
    }
    protected override void behaviour()
    {
        base.behaviour();
    }
    protected override void MoveToPos(Vector3 pos)
    {

        targetPos = CameraManager.Instance.Player.position + Vector3.up * 0.5f;
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
                LookAtPos(targetPos);
                gun.transform.LookAt(CameraManager.Instance.Player.position);
                // targetPos = CameraManager.Instance.Player.transform.position;
                transform.RotateAround(targetPos, new Vector3(0, 1, 0), 10 * Time.deltaTime);
                if (gun.lightBullet != null)
                {
                    gun.lightBullet.transform.position = gun.transform.position;
                    gun.lightBullet.transform.forward = gun.transform.forward;
                }

                // gun.Shoot();

                //targetPos = CameraManager.Instance.Player.transform.position;
                // transform.LookAt(targetPos);
                //   gun.transform.LookAt(targetPos);
                shootTime -= Time.deltaTime;
                if (shootTime <= 0)
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


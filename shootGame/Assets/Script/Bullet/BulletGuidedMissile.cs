using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
//导弹
  public class BulletGuidedMissile: Enemy
{
    public float damage = 10;//撞击飞船伤害
    private string colliderEffect = "smallHit";
    public override void Awake()
    {
        base.Awake();
        Active();
    }

    public override void Active()
    {
        base.Active();
        this.transform.eulerAngles = Vector3.zero;
    }
    protected override void MoveToPos(Vector3 pos)
    {
        LookAtPos(pos);
        base.MoveToPos(pos);

    }

    //状态切换调用
    public override void switchState(ShipState _State)
    {
        if(_State== ShipState.Move)
        {
            this.transform.parent = GunManager.Ships.transform;
        }
    }
    protected override void behaviour()
    {
        base.behaviour();
    }

    //到达目标点 追逐玩家
    protected override void ArrivePos(Vector3 pos)
    {
        base.ArrivePos(pos);
        targetPos = CameraManager.Instance.Player.position;
        MoveToPos(CameraManager.Instance.Player.position);
    }

    //攻击玩家 条件和行为
    protected override void attackPlayer()
    {
        base.attackPlayer();
        targetPos = CameraManager.Instance.Player.position;
        MoveToPos(CameraManager.Instance.Player.position);
    }




    public override void Dead()
    {
        base.Dead();
    }

    public override void OnTriggerEnter(Collider other)
    {

        if (other.tag == Tags.player)
        {
            //  Debug.Log(Time.time+"ShipA0203p OnTriggerEnter=" + damage);

            ShipBase ship = other.gameObject.GetComponent<ShipBase>();
            if (ship != null)
            {
                ship.Damage(damage, this.gameObject);
                //  Debug.Log(this.gameObject.name + " damage " + damage);
            }
            this.gameObject.SetActive(false);
            colliderDead();
        }
    }

    public void colliderDead()
    {
        if (!string.IsNullOrEmpty(colliderEffect))
        {
            GameObject obj = MyUtils.LoadEffectPrefab(colliderEffect, false);
            if (obj != null)
            {
                obj.transform.position = this.transform.position;
            }
        }
        Dead();
    }
}


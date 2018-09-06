using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum EnemyShipType
{
    FarAttack,
    earAttack
}
public enum ShipState
{
    stop,
    Move,

    none
}
public class Enemy : ShipBase
{
    public EnemyShipType shipType = EnemyShipType.earAttack;
    private Blood blood;//是否要血条,预制件添加
    public Vector3 targetPos;//目标点

    //路径点
    public List<Vector3> pathList = new List<Vector3>();
    protected float stopBehaviorTime = 2;
    public float RotateSpeed = 4;
    protected Quaternion targetRotation;

    private Transform tailTransform;//尾飞行器

    public override void Awake()
    {
        base.Awake();
        blood = this.transform.GetComponent<Blood>();
        tailTransform = this.transform.Find("tail");
    }
    public virtual void Start()
    {
        if (blood != null)
        {
            blood.totalVaue = life;
        }
        setState = ShipState.stop;
    }
    public override void Active()
    {
        base.Active();
        if (blood != null)
        {
            blood.totalVaue = life;
        }
        getNextPos();
        stopBehaviorTime = 2;
        setState = ShipState.stop;
    }
    public virtual void Update()
    {
        behaviour();

    }
    protected virtual void behaviour()
    {
        if (stopBehaviorTime > 0)
        {
            stopBehaviorTime -= Time.deltaTime;
            setState = ShipState.stop;
            return;
        }
        MoveToPos(targetPos);
        lookTargetRotate();
    }

    //移动到目标点
    protected virtual void MoveToPos(Vector3 pos)
    {
        float distance = Vector3.Distance(gameObject.transform.position, targetPos);
        if (Vector3.Distance(gameObject.transform.position, targetPos) < speed * Time.deltaTime)
        {
            ArrivePos(targetPos);
            return;
        }
        gameObject.transform.position = Vector3.MoveTowards(gameObject.transform.position, targetPos, speed * Time.deltaTime);
        setState = ShipState.Move;
    }
    public virtual void lookTargetRotate()
    {
        if(isReadRote)
        {
            return;
        }
        Quaternion newRotation = Quaternion.Lerp(transform.rotation, targetRotation, RotateSpeed * Time.deltaTime);
        transform.rotation = newRotation;
    }
    public virtual void LookAtPos(Vector3 lookPos)
    {
        Vector3 forwardPos = lookPos - transform.position;
        if (forwardPos == Vector3.zero)
        {
            return;
        }
         targetRotation = Quaternion.LookRotation(forwardPos, Vector3.up);
    }
    protected bool isReadRote
    {
        get
        {
            float angel = Quaternion.Angle(targetRotation, transform.rotation);
            if (angel <= 1f&& angel >= -1f)
            {
                return true;
            }
            return false;
        }
    }

    //到达目标点 行为
    protected virtual void ArrivePos(Vector3 pos)
    {
        if (pathList.Count > 0)
        {
            targetPos = pathList[0];
            pathList.Remove(targetPos);
        }
        
    }
    private Vector3 getNextPos()
    {
        if (pathList.Count > 0)
        {

            targetPos = pathList[0];
            pathList.Remove(targetPos);
             
        }
        return targetPos;
    }
    //攻击玩家行为
    protected virtual void attackPlayer()
    {
        
     
    }

    public override void Damage(float num, GameObject target = null)
    {
        base.Damage(num, target);
        if (life <= 0)
        {
            MonsterManager.Instance.addScore(10);
        }
        if (blood == null)
            return;
        blood.setBloodValue = life;

    }
    public void stopAttrackTime(float time)
    {
        stopBehaviorTime = time;
    }

    public override void Dead()
    {
        base.Dead();
        MonsterManager.Instance.destoy(this.gameObject);
        ResourceManagerPool.Instance.ReturnPoolObject(prefabName, ResourceType.ship, gameObject);
    }
    public override void switchState(ShipState _State)
    {

        switch (_State)
        {
            case ShipState.stop:
                if (tailTransform!=null)
                {
                    tailTransform.gameObject.SetActive(false);
                }
                    break;
            case ShipState.Move:
                if (tailTransform != null)
                {
                    tailTransform.gameObject.SetActive(true);
                }
                break;
        }
    }

}

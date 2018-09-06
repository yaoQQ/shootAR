using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//激光
public class Bullet1014p : Bullet
{

    public float currDistace = 1f;//激光距离
    public float maxDistace = 5;
    public float hitRate = 0.2f;

    private GameObject BoomEffect;
    private bool isHit = false;


    public override void Active()
    {
        base.Active();
        timeLife = hitRate;
        isHit = false;
        currDistace = 1;
    }
    public override void Update()
    {
        if (isHit)
            return;
        currDistace += Time.deltaTime * ButtleSpeed;
        currDistace = currDistace > maxDistace ? maxDistace : currDistace;
        Debug.DrawRay(transform.position, this.transform.forward, Color.yellow, currDistace);


        updateShoot(currDistace);

    }

    private GameObject hitTarget;
    public void OnTriggerStay(Collider other)
    {
      //  Debug.Log("OnTriggerStay");
        if (shootTag == null)
            return;
        if (!other.tag.Equals(shootTag))
        {
            isHit = false;
            return;
        }
        //      Debug.Log("OnTriggerStay()");
        isHit = true;
        timeLife -= Time.deltaTime;
        if (timeLife <= 0)//一次打击间隔
        {
            RaycastHit[] hitObjs = Physics.RaycastAll(transform.position, this.transform.forward, currDistace);
          //  Debug.Log("hitObjs length=" + hitObjs.Length);
            for (int i = 0; i < hitObjs.Length; i++)
            {
                RaycastHit hit = hitObjs[i];

                if (!hit.collider.tag.Equals(shootTag))//可能其他碰撞体，是敌方类型执行
                {
                    continue;
                }
                Vector3 hitPos = hit.point;
                currDistace = Vector3.Distance(this.transform.position, hitPos);//+MyUtils.ArkitScale 使激光一直在对象内部不离开碰撞范围
                hitTarget = other.gameObject;
                showHitEffect(hitPos);
               // Debug.Log("hit "+ shootTag+ "  hitPos= "+ hitPos);
                break;
            }
            updateShoot(currDistace);
            ShipBase ship = other.gameObject.GetComponent<ShipBase>();
            Vector3 pos = ship.transform.position;
            if (ship != null)
            {
                ship.Damage(ButtleDamage,this.gameObject);
              //  Debug.Log("hit " + shootTag + "  ButtleDamage= " + ButtleDamage);
            }
            timeLife = hitRate;
        }




    }

    private void rest()
    {

    }
    public void OnTriggerExit(Collider other)
    {
    //    Debug.Log("OnTriggerExit");
        notHit();

    }
    private void notHit()
    {

        isHit = false;
        if (BoomEffect != null)
            BoomEffect.SetActive(false);

        //Debug.Log("notHit");
    }

    private void updateShoot(float distance)
    {
        this.transform.localScale = new Vector3(this.transform.localScale.x, this.transform.localScale.y, -0.1f * distance);
        if (hitTarget == null)//敌方摧毁，打击特效不消失bug
        {
            notHit();
          //  Debug.Log("updateShoot notHit");
        }
    }

    public override void OnTriggerEnter(Collider other)
    {

    }
    private void showHitEffect(Vector3 pos)
    {
        if (BoomEffect != null)
        {
            BoomEffect.transform.position = pos;
            BoomEffect.SetActive(true);
            return;
        }
        if (!string.IsNullOrEmpty(BoomEffectName))
        {
            BoomEffect = MyUtils.LoadEffectPrefab(BoomEffectName);
            if (BoomEffect != null)
            {
                BoomEffect.transform.position = pos;
                BoomEffect.gameObject.SetActive(true);
            }
            //  GameObject.Destroy(BoomEffect.gameObject, 1);
        }
    }
    /// <summary>
    /// 重新激活子弹
    /// </summary>
    public override void ReAcvtive()
    {
        timeLife = hitRate;
        this.gameObject.SetActive(true);

    }
    /// <summary>
    /// 重新取消子弹
    /// </summary>
    public override void DisAcvtive()
    {

        this.gameObject.SetActive(false);
        if (BoomEffect != null)
            BoomEffect.SetActive(false);
        currDistace = 1f;
        updateShoot(currDistace);
      //  Debug.Log("DisAcvtive");
    }

    public override void OnDestroy()
    {
        GameObject.Destroy(BoomEffect);
    }
}

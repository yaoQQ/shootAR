using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet1041p : Bullet
{
    // public GameObject enemyTarget;
    // Use this for initialization
    public float exploreTime = 1;
    public bool isShowEffect = true;

    public override void Active()
    {
        base.Active();
        timeLife = exploreTime;
    }
    public override void Update()
    {
       
        transform.Translate(Vector3.forward * Time.deltaTime * ButtleSpeed);
        timeLife -= Time.deltaTime;
        if (timeLife <= 0)
        {
           
            showSmallEffect();
            DisAcvtive();
            isShowEffect = false;
        }
    }
    /// <summary>
    /// 重新激活子弹
    /// </summary>
    public override void ReAcvtive()
    {
        timeLife = exploreTime;
        isShowEffect = true;
        this.gameObject.SetActive(true);

    }
    public override void DisAcvtive()
    {
        if (isShowEffect)
        {
            this.gameObject.SetActive(false);
        }
        else
        {
            GameObject.Destroy(this.gameObject);
        }

    }
    private void showSmallEffect()
    {
        if (!isShowEffect)
        {
            return;
        }
        for (int i = 0; i <10; i++)
        {
            GameObject go = MyUtils.Instantiate(this.gameObject) as GameObject;
            go.transform.position = this.transform.position;
            go.transform.rotation = this.transform.rotation * Quaternion.Euler(Random.Range(-10, 10), Random.Range(-10,10),0);
            Bullet1041p smallBullet = go.GetComponent<Bullet1041p>();
            go.transform.localScale = Vector3.one * 0.02f;
            smallBullet.isShowEffect = false;
            smallBullet.exploreTime = 4f;
            go.SetActive(true);
        }
    }
}

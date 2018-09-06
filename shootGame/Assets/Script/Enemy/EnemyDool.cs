using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDool : EffectItem
{

    public Enemy enemy;
    public Transform enemyPos;

    public void Awake()
    {
        enemyPos = this.transform.Find("createEnemy");
       
    }
    public override void Active()
    {
        this.transform.localScale = Vector3.one;
    }

    public override void Update()
    {
        //liveTime -= Time.deltaTime;
        //if (liveTime <= 0)
        //{
        //    this.gameObject.SetActive(false);
        //    if (!String.IsNullOrEmpty(prefabName))
        //        ResourceManagerPool.Instance.ReturnPoolObject(prefabName, ResourceType.effect, this.gameObject);
        //}
    }
    public void showDoll(Enemy obj)
    {
        bool isBoss = obj is ShipBoss;
        this.transform.position = MyUtils.findPlayerCirclePos2(2, isBoss);
        this.transform.LookAt(CameraManager.Instance.Player);
        enemy = obj;
        if (enemy != null)
        {
            enemy.gameObject.SetActive(false);
            enemy.transform.position = enemyPos.transform.position;
            enemy.transform.forward = this.transform.forward;
            enemy.pathList = new List<Vector3> { enemy.transform.position+this.transform.forward*0.5f, CameraManager.Instance.Player.position };
        }
        this.gameObject.SetActive(true);
        iTween.ScaleFrom(this.gameObject, iTween.Hash("scale",
          new Vector3(0.1f, 0.1f, 0.1f),
          "time", 2f,
          "islocal", true,
           "oncomplete", "showComplete",
          "oncompletetarget", this.gameObject,
          "oncompleteparams", true,
          "easetype", iTween.EaseType.easeInOutBack
          ));
    }
    public void showDoll()
    {

        this.transform.LookAt(CameraManager.Instance.Player);
        this.gameObject.SetActive(true);
        iTween.ScaleFrom(this.gameObject, iTween.Hash("scale",
          new Vector3(0.1f, 0.1f, 0.1f),
          "time", 2f,
          "islocal", true,
           "oncomplete", "showComplete",
          "oncompletetarget", this.gameObject,
          "oncompleteparams", true,
          "easetype", iTween.EaseType.easeInOutBack
          ));
    }
    private void showComplete()
    {
        this.transform.localScale = Vector3.one;
        StartCoroutine(showEnemy());
    }

    IEnumerator showEnemy()
    {
        if(enemy!=null)
        enemy.gameObject.SetActive(true);
        DecalController decal= enemy.GetComponent<DecalController>();
        if (decal != null)
        {
            decal.BeginLeapIn();
        }
        yield return new WaitForSeconds(3);
        iTween.ScaleTo(this.gameObject, iTween.Hash("scale",
         new Vector3(0.1f, 0.1f, 0.1f),
         "time", 1f,
         "islocal", true,
          "oncomplete", "DisActive",
         "oncompletetarget", this.gameObject,
         "oncompleteparams", true,
         "easetype", iTween.EaseType.easeInBack
         ));
    }
    public void DisActive()
    {
        this.transform.localScale = Vector3.one;
        this.gameObject.SetActive(false);
        ResourceManagerPool.Instance.ReturnPoolObject(prefabName, ResourceType.effect, this.gameObject);
    }


}

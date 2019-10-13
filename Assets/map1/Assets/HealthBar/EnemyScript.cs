using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyScript : MonoBehaviour
{
    public Transform player;
    static Animator anim;
    public GameObject Powerpee;
    private void Start()
    {
        anim = GetComponent<Animator>();
    }
    private void Update()
    {
        if(Vector3.Distance(player.position, this.transform.position) < 100)
        {
            Vector3 direction = player.position - this.transform.position;
            direction.y = 0;
            this.transform.rotation = Quaternion.Slerp(this.transform.rotation,
                                      Quaternion.LookRotation(direction), 0.1f);
            anim.SetBool("isIdle", false);
            if (direction.magnitude > 2f)
            {
                this.transform.Translate(0, 0, 0.02f);
                anim.SetBool("isWalking", true);
                anim.SetBool("isAttacking", false);
            }
            else
            {
                if (Powerpee.active == false)
                {
                    anim.SetBool("isAttacking", true);
                    Powerpee.SetActive(true);
                }
               anim.SetBool("isWalking", false);
    
            }
        }
        else
        {
            anim.SetBool("isIdle",true);
            anim.SetBool("isWalking",false);
            anim.SetBool("isAttacking",false);
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player"){
            HealthBarScript.health -= 10f;
            Debug.Log("-10");
        }
        
    }
}
